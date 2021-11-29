import abc
import argparse
import enum
import logging
import os
import subprocess
import time
import typing

import requests
import yaml


class Action(object):
    """Base class for difference actions."""

    __metaclass__ = abc.ABCMeta

    def __init__(self, context: typing.Dict, verbose=False):
        self._context = context
        self._verbose = verbose

    @abc.abstractmethod
    def deploy(self) -> None:
        raise NotImplementedError()

    @abc.abstractclassmethod
    def is_usable(cls, config: dict) -> bool:
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
        context: dict,
        command_template: str,
        strings: typing.Dict[PkgStatus, str],
    ):
        super().__init__(context)
        self._strings = {}
        self._command_template = command_template
        self._strings = strings

    @classmethod
    def is_usable(cls, config: dict) -> bool:
        return any([val in config for val in cls._keys])

    def deploy(self) -> None:
        logging.info(str(self._keys))
        for key in self._keys:
            if key in self._context:
                logging.info("Processing {}".format(key))
                self._process(self._context[key])

    def _process(self, packages):
        results = {}
        successful = [
            PkgStatus.UP_TO_DATE,
            PkgStatus.UPDATED,
            PkgStatus.INSTALLED,
        ]

        for pkg in packages:
            if isinstance(pkg, dict):
                logging.error("Incorrect format")
            elif isinstance(pkg, list):
                # logging.error('Incorrect format')
                pass
            else:
                pass
            result = self._install(pkg)
            results[result] = results.get(result, 0) + 1
            if result not in successful:
                logging.error("Could not install package '{}'".format(pkg))

        if all([result in successful for result in results.keys()]):
            logging.info("\nAll packages installed successfully")
            success = True
        else:
            success = False

        for status, amount in results.items():
            log = logging.info if status in successful else logging.error
            log("{} {}".format(amount, status.value))

        return success

    def _install(self, pkg):
        # to have a unified string which we can query
        # we need to execute the command with LANG=en_US
        cmd = self._command_template.format(pkg)

        logging.info('Installing "{}". Please wait...'.format(pkg))

        # needed to avoid conflicts due to locking
        time.sleep(1)

        proc = subprocess.Popen(
            cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT
        )
        out = proc.stdout.read()
        proc.stdout.close()

        for item in self._strings.keys():
            if out.decode("utf-8").find(self._strings[item]) >= 0:
                return item

        logging.warning(
            "Could not determine what happened with package {}".format(pkg)
        )
        return PkgStatus.NOT_SURE


class Yay(PackageManager):
    """Download from yay."""

    _keys = ["pacman", "yay"]

    def __init__(self, context: dict):
        strings = {
            PkgStatus.ERROR: "aborting",
            PkgStatus.NOT_FOUND: "Could not find all required packages",
            PkgStatus.UPDATED: "Net Upgrade Size:",
            PkgStatus.INSTALLED: "Total Installed Size:",
            PkgStatus.UP_TO_DATE: "is up to date -- skipping",
        }
        super().__init__(
            context, "LANG=en_US yay --needed --noconfirm -S {}", strings
        )


class Apt(PackageManager):
    """Download from apt."""

    _keys = ["apt"]

    def __init__(self, context: dict):
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
    """Download from apt."""

    _keys = ["pip"]

    def __init__(self, context: dict):
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


class Wget(Action):
    """Download from urls."""

    _key = "wget"

    def __init__(self, *args, **kwargs):
        super(Wget, self).__init__(*args, **kwargs)

    @classmethod
    def is_usable(cls, config: dict) -> bool:
        return cls._key in config

    def chmod_digit(self, file_path: str, perms: int = 755) -> None:
        os.chmod(file_path, int(str(perms), base=8))

    def deploy(self) -> None:
        local_path = self._context["opts"]["local_path"]
        overwrite = self._context["opts"].get("overwrite", False)
        for fname, url in self._context[self._key].items():
            fname_abs = os.path.abspath(
                os.path.expanduser(os.path.join(local_path, fname))
            )
            logging.info("Downloading {} to {}".format(fname, local_path))
            if os.path.exists(fname_abs):
                if overwrite:
                    logging.info("Overwriting {}".format(fname))
                else:
                    logging.error("Existed: {}".format(fname))
            self.download_file(fname_abs, url)
            self.chmod_digit(fname_abs)

    def download_file(self, fname: typing.AnyStr, url: typing.AnyStr) -> None:
        with open(fname, "wb") as f:
            r = requests.get(url, allow_redirects=True)
            f.write(r.content)


def guess_type(config: typing.Dict) -> Action:
    for cls in [Wget, Yay, Apt, Pip]:
        if cls.is_usable(config):
            logging.info("Use action: {}".format(cls.__name__))
            return cls(config)
    raise ValueError("Unknown config with keys: {}".format(list(config.keys())))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install packages.")
    parser.add_argument("config_file", type=str, help="where is the local path")
    parser.add_argument(
        "--log_level", type=str, default="info", help="log level"
    )
    args = parser.parse_args()

    logging.basicConfig(
        format="%(asctime)s [%(levelname)-5.5s] [%(process)d] (%(name)s) %(message)s",
        level=getattr(logging, args.log_level.upper()),
    )

    with open(args.config_file, "r") as f:
        config = yaml.load(f, Loader=yaml.SafeLoader)

    action = guess_type(config)
    action.deploy()
