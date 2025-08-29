"""Install package.

Usage:
    python install-package.py ${config_path}
"""

import abc
import argparse
import enum
import logging
import os
import subprocess
import time
from types import MappingProxyType
from typing import Any, Dict, List, Mapping

import yaml


def make_immutable_config(config: Dict[str, Any]) -> Mapping[str, Any]:
    """Convert a configuration dict to an immutable mapping."""
    return MappingProxyType(config)


class Action(abc.ABC):
    """Base class for difference actions."""

    def __init__(self, context: Mapping[str, Any], verbose: bool = False):
        self._context = context
        self._verbose = verbose

    @abc.abstractmethod
    def deploy(self) -> None:
        raise NotImplementedError()

    @classmethod
    @abc.abstractmethod
    def is_usable(cls, config: Mapping[str, Any]) -> bool:
        del config
        raise NotImplementedError()


class PkgStatus(enum.Enum):
    # These names will be displayed
    UP_TO_DATE = "Up to date"
    INSTALLED = "Installed"
    UPDATED = "Updated"
    NOT_FOUND = "Not Found"
    ERROR = "Error"
    NOT_SURE = "Could not determine"


class PackageManager(Action):
    """Download from Package Manager.
    Modified from https://github.com/OxSon/dotbot-yay
    """

    _keys = []

    def __init__(
        self,
        context: Mapping[str, Any],
        command_template: str,
        strings: Mapping[PkgStatus, str],
    ):
        super().__init__(context)
        self._strings: Dict[PkgStatus, str] = {}
        self._command_template = command_template
        self._strings = dict(strings)  # Create a copy as dict

    @classmethod
    def is_usable(cls, config: Mapping[str, Any]) -> bool:
        return any(val in config for val in cls._keys)

    def deploy(self) -> None:
        logging.info(str(self._keys))
        for key in self._keys:
            if key in self._context:
                logging.info("Processing %s", key)
                packages = self._context[key]
                if not isinstance(packages, list):
                    logging.error(
                        "Package list for %s must be a list, got %s",
                        key,
                        type(packages),
                    )
                    continue
                self._process(packages)

    def _process(self, packages: List[str]) -> bool:
        results: Dict[PkgStatus, int] = {}
        successful = [
            PkgStatus.UP_TO_DATE,
            PkgStatus.UPDATED,
            PkgStatus.INSTALLED,
        ]

        for pkg in packages:
            if not isinstance(pkg, str):
                logging.error("Package name must be a string, got: %s", type(pkg))
                continue

            result = self._install(pkg)
            results[result] = results.get(result, 0) + 1
            if result not in successful:
                logging.error("Could not install package '%s'", pkg)

        if all(result in successful for result in results.keys()):
            logging.info("\nAll packages installed successfully")
            success = True
        else:
            success = False

        for status, amount in results.items():
            log = logging.info if status in successful else logging.error
            log("%s %s", amount, status.value)

        return success

    def _install(self, pkg: str) -> PkgStatus:
        # to have a unified string which we can query
        # we need to execute the command with LANG=en_US
        cmd = self._command_template.format(pkg)

        logging.info('Installing "%s". Please wait...', pkg)

        # needed to avoid conflicts due to locking
        time.sleep(1)

        proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        if proc.stdout is None:
            logging.warning("Failed to fetch stdout")
            return PkgStatus.NOT_SURE
        out = proc.stdout.read()
        proc.stdout.close()

        for item in self._strings.keys():
            if out.decode("utf-8").find(self._strings[item]) >= 0:
                return item

        logging.warning("Could not determine what happened with package %s", pkg)
        return PkgStatus.NOT_SURE


class Yay(PackageManager):
    """Download from yay."""

    _keys = ["pacman", "yay"]

    def __init__(self, context: Mapping[str, Any]):
        strings = {
            PkgStatus.ERROR: "aborting",
            PkgStatus.NOT_FOUND: "Could not find all required packages",
            PkgStatus.UPDATED: "Net Upgrade Size:",
            PkgStatus.INSTALLED: "Total Installed Size:",
            PkgStatus.UP_TO_DATE: "is up to date -- skipping",
        }
        super().__init__(context, "LANG=en_US yay --needed --noconfirm -S {}", strings)


class Apt(PackageManager):
    """Download from apt."""

    _keys = ["apt"]

    def __init__(self, context: Mapping[str, Any]):
        strings = {
            PkgStatus.NOT_FOUND: "Unable to locate package",
            PkgStatus.INSTALLED: "",
            PkgStatus.UP_TO_DATE: "is already the newest",
        }
        super().__init__(
            context,
            "LANG=en_US apt install -y --no-install-recommends {}",
            strings,
        )


class Pip(PackageManager):
    """Download from pip."""

    _keys = ["pip"]

    def __init__(self, context: Mapping[str, Any]):
        strings = {
            PkgStatus.NOT_FOUND: "No matching distribution found",
            PkgStatus.INSTALLED: "Successfully installed",
            PkgStatus.UP_TO_DATE: "Requirement already satisfied",
        }
        super().__init__(
            context,
            "LANG=en_US pip3 install --upgrade {}",
            strings,
        )


class Brew(PackageManager):
    """Download from Homebrew."""

    _keys = ["brew"]

    def __init__(self, context: Mapping[str, Any]):
        strings = {
            PkgStatus.ERROR: "Error:",
            PkgStatus.NOT_FOUND: "No available formula with the name",
            PkgStatus.UP_TO_DATE: "already installed and up-to-date",
            # If no other status is found, assume it was installed successfully.
            PkgStatus.INSTALLED: "",
        }
        super().__init__(
            context,
            "HOMEBREW_NO_AUTO_UPDATE=1 brew install {}",
            strings,
        )


class Wget(Action):
    """Download from urls."""

    _key = "wget"

    def __init__(self, context: Mapping[str, Any], verbose: bool = False):
        super().__init__(context, verbose)

    @classmethod
    def is_usable(cls, config: Mapping[str, Any]) -> bool:
        return cls._key in config

    def chmod_digit(self, file_path: str, perms: int = 755) -> None:
        os.chmod(file_path, int(str(perms), base=8))

    def deploy(self) -> None:
        local_path = self._context["opts"]["local_path"]
        overwrite = self._context["opts"].get("overwrite", False)

        wget_config = self._context.get(self._key, {})
        if not isinstance(wget_config, dict):
            logging.error("wget configuration must be a dictionary")
            return

        for fname, url in wget_config.items():
            fname_abs = os.path.abspath(os.path.expanduser(os.path.join(local_path, fname)))
            logging.info("Downloading %s to %s", fname, local_path)
            if os.path.exists(fname_abs):
                if overwrite:
                    logging.info("Overwriting %s", fname)
                else:
                    logging.error("Existed: %s", fname)
                    continue
            self.download_file(fname_abs, url)
            self.chmod_digit(fname_abs)

    def download_file(self, fname: str, url: str) -> None:
        import requests

        with open(fname, "wb") as f:
            r = requests.get(url, allow_redirects=True)
            f.write(r.content)


def guess_type(config: Mapping[str, Any]) -> Action:
    for cls in [Wget, Yay, Apt, Pip, Brew]:
        if cls.is_usable(config):
            logging.info("Use action: %s", cls.__name__)
            return cls(config)
    raise ValueError(f"Unknown config with keys: {list(config.keys())}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install packages.")
    parser.add_argument("config_file", type=str, help="where is the local path")
    parser.add_argument("--log_level", type=str, default="info", help="log level")
    args = parser.parse_args()

    logging.basicConfig(
        format="%(asctime)s [%(levelname)-5.5s] [%(process)d] (%(name)s) %(message)s",
        level=getattr(logging, args.log_level.upper()),
    )

    with open(args.config_file) as f:
        config = yaml.load(f, Loader=yaml.SafeLoader)

    if config is None:
        raise ValueError("Config file is empty or invalid")

    if not isinstance(config, dict):
        raise ValueError(f"Config must be a dictionary, got {type(config)}")

    # Convert to immutable configuration
    immutable_config = make_immutable_config(config)

    action = guess_type(immutable_config)
    action.deploy()
