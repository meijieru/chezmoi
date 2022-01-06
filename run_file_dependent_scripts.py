#!/usr/bin/env python3
"""
Chezmoi script to run scripts based on dependent files changing.

Modified from https://gist.github.com/karlwbrown/7e48ebfdc3c14b3c879880d88bd77f66
"""
import collections
import hashlib
import logging
import os
import subprocess
import tempfile
from typing import Dict, Final, List

# Expects a file of the format output by sha256sum (text mode)
CHECKSUM_FILE: Final = "data/tmp/local_checksum"

# Global mapping between files/dirs & scripts
DEPENDENCIES_MAPS = [
    {
        "script": "./tools/install_package/archlinux.sh.tmpl",
        "dependent_dirs": ["./data/packages/arch"],
        # "dependent_files": [],
    },
    {
        "script": "./tools/install_package/debian.sh.tmpl",
        "dependent_dirs": ["./data/packages/debian"],
    },
    {
        "script": "./tools/install_package/ubuntu.sh.tmpl",
        "dependent_dirs": ["./data/packages/ubuntu"],
    },
]


def get_all_files(directory: str) -> List[str]:
    res = []
    for root, _, files in os.walk(directory):
        for item in files:
            fpath = str(os.path.join(root, item))
            res.append(fpath)
    return res


def get_dependencies() -> Dict[str, List[str]]:
    res = collections.defaultdict(list)
    for dep in DEPENDENCIES_MAPS:
        script = dep["script"]

        deps = []
        if "dependent_files" in dep:
            deps.extend(dep["dependent_files"])
        if "dependent_dirs" in dep:
            for dirc in dep["dependent_dirs"]:
                deps.extend(get_all_files(dirc))

        for val in deps:
            if script not in res[val]:
                res[val].append(script)

    return res


def create_checksum_file(checksum_target_files: List[str]) -> None:
    logging.info("Creating checksum file")
    sha_args = ["sha256sum"] + checksum_target_files
    with open(CHECKSUM_FILE, mode="w") as checksum_file:
        subprocess.run(sha_args, check=True, stdout=checksum_file)


def UmaskNamedTemporaryFile(*args, perms: int = 0o700, **kargs):
    """
    https://stackoverflow.com/a/44130605/4453332
    """
    fdesc = tempfile.NamedTemporaryFile(*args, **kargs)
    os.chmod(fdesc.name, perms)
    return fdesc


def run_file(fname: str) -> None:
    base_name, ext = os.path.splitext(os.path.basename(fname))
    if ext in [".tmpl"]:
        with UmaskNamedTemporaryFile(
            suffix=base_name, delete=False
        ) as tmp_file:
            subprocess.run(
                ["chezmoi", "execute-template"],
                stdin=open(fname, "r"),
                stdout=tmp_file,
                check=True,
                encoding="utf-8",
            )
        subprocess.run(tmp_file.name, check=True)
        os.remove(tmp_file.name)
    else:
        subprocess.run(fname, check=True)


def verify_checksums(
    existing_checksum_map: Dict[str, str], dependencies: Dict[str, List[str]]
) -> bool:
    checksum_refresh = False
    to_executes = set()

    for fpath, exes in dependencies.items():
        with open(fpath, "rb") as dep_file:
            file_bytes = dep_file.read()
            hash = hashlib.sha256(file_bytes).hexdigest()
            if (
                fpath not in existing_checksum_map
                or hash != existing_checksum_map[fpath]
            ):
                logging.info("Hashes mismatch: {}".format(fpath))
                checksum_refresh = True
                to_executes.update(exes)
            else:
                logging.info("Hashes match: {}".format(fpath))

    for exe in to_executes:
        logging.info("Running: {}".format(exe))
        run_file(exe)
    return checksum_refresh


def main() -> None:
    logging.basicConfig(
        format="%(asctime)s [%(levelname)-5.5s] [%(process)d] (%(name)s) %(message)s",
        level=logging.INFO,
    )

    result = subprocess.run(
        ["chezmoi", "source-path"],
        check=True,
        capture_output=True,
        encoding="utf-8",
    )
    os.chdir(result.stdout.strip())
    existing_checksum_map = {}
    try:
        with open(CHECKSUM_FILE) as f:
            for line in f:
                tokenized = line.strip().split(maxsplit=1)
                existing_checksum_map[tokenized[1]] = tokenized[0]
    except FileNotFoundError:
        logging.info("Checksum file not found. Will create at the end...")

    deps = get_dependencies()
    checksum_refresh = verify_checksums(existing_checksum_map, deps)

    # Refresh checksums if needed
    if checksum_refresh:
        create_checksum_file(list(deps.keys()))


if __name__ == "__main__":
    main()
