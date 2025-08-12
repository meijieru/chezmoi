#!/usr/bin/env python3
"""Chezmoi file dependency tracker and script runner.

This script monitors file dependencies and automatically runs associated scripts
when those dependencies change. It maintains SHA256 checksums to detect changes
and supports conditional execution based on file modifications.

The script is designed to work with chezmoi templates and can execute both
regular scripts and template files that need preprocessing.

Examples:
    # Run dependency checks and execute scripts if files changed
    ./run_file_dependent_scripts.py

    # Update checksums without running dependency checks
    ./run_file_dependent_scripts.py --skip_install

Modified from: https://gist.github.com/karlwbrown/7e48ebfdc3c14b3c879880d88bd77f66
"""

import argparse
import collections
import hashlib
import logging
import os
import subprocess
import tempfile
from pathlib import Path
from typing import Final, TypedDict

# Path to the checksum file (expects sha256sum text format)
CHECKSUM_FILE: Final[str] = "data/tmp/local_checksum"


class DependencyMap(TypedDict):
    """Type definition for dependency mapping configuration.

    Attributes:
        script: Path to the script to execute when dependencies change
        dependent_dirs: List of directory paths to monitor for changes
        dependent_files: List of file paths to monitor for changes
    """

    script: str
    dependent_dirs: list[str]
    dependent_files: list[str]


# Global mapping between files/directories and their associated scripts
DEPENDENCY_MAPS: Final[list[DependencyMap]] = [
    {
        "script": "./tools/install_package/archlinux.sh.tmpl",
        "dependent_dirs": ["./data/packages/arch"],
        "dependent_files": [],
    },
    {
        "script": "./tools/install_package/debian.sh.tmpl",
        "dependent_dirs": ["./data/packages/debian"],
        "dependent_files": [],
    },
    {
        "script": "./tools/install_package/ubuntu.sh.tmpl",
        "dependent_dirs": ["./data/packages/ubuntu"],
        "dependent_files": [],
    },
]


def get_all_files(directory: str) -> list[str]:
    """Recursively get all file paths within a directory.

    Args:
        directory: The directory path to scan recursively

    Returns:
        A list of all file paths found in the directory tree
    """
    res = []
    for root, _, files in os.walk(directory):
        for item in files:
            fpath = str(Path(root) / item)
            res.append(fpath)
    return res


def get_dependencies() -> dict[str, list[str]]:
    """Build a mapping of dependency files to their associated scripts.

    Processes the DEPENDENCY_MAPS configuration to create a reverse mapping
    where each file/directory maps to the scripts that depend on it.

    Returns:
        Dictionary mapping file paths to lists of scripts that depend on them
    """
    res = collections.defaultdict(list)
    for dep in DEPENDENCY_MAPS:
        script = dep["script"]

        deps = []
        if "dependent_files" in dep:
            deps.extend(dep["dependent_files"])
        if "dependent_dirs" in dep:
            for directory in dep["dependent_dirs"]:
                deps.extend(get_all_files(directory))

        for dependency_path in deps:
            if script not in res[dependency_path]:
                res[dependency_path].append(script)

    return res


def create_checksum_file(checksum_target_files: list[str]) -> None:
    """Create a checksum file for the specified target files.

    Uses sha256sum to generate checksums for all target files and writes
    them to the designated checksum file.

    Args:
        checksum_target_files: List of file paths to generate checksums for
    """
    logging.info("Creating checksum file")
    sha_args = ["sha256sum"] + checksum_target_files
    with Path(CHECKSUM_FILE).open(mode="w") as checksum_file:
        subprocess.run(sha_args, check=True, stdout=checksum_file)


def create_umask_named_temporary_file(*args, permissions: int = 0o700, **kwargs) -> tempfile._TemporaryFileWrapper:
    """Create a named temporary file with specific permissions.

    This function addresses the security issue where NamedTemporaryFile
    creates files with overly permissive default permissions.

    Args:
        *args: Positional arguments passed to NamedTemporaryFile
        permissions: File permissions to set (default: 0o700)
        **kwargs: Keyword arguments passed to NamedTemporaryFile

    Returns:
        A NamedTemporaryFile object with the specified permissions

    Reference:
        https://stackoverflow.com/a/44130605/4453332
    """
    file_descriptor = tempfile.NamedTemporaryFile(*args, **kwargs)
    os.chmod(file_descriptor.name, permissions)
    return file_descriptor


def run_file(file_path: str) -> None:
    """Execute a file, with special handling for template files.

    Template files (.tmpl extension) are first processed through chezmoi's
    execute-template command before execution. Regular files are executed directly.

    Args:
        file_path: Path to the file to execute
    """
    path = Path(file_path)
    base_name, extension = path.stem, path.suffix

    if extension == ".tmpl":
        # Process template file through chezmoi and execute the result
        with create_umask_named_temporary_file(suffix=base_name, delete=False) as tmp_file:
            subprocess.run(
                ["chezmoi", "execute-template"],
                stdin=open(file_path, encoding="utf-8"),
                stdout=tmp_file,
                check=True,
            )
        subprocess.run(tmp_file.name, check=True)
        os.remove(tmp_file.name)
    else:
        # Execute regular file directly
        subprocess.run(file_path, check=True)


def verify_checksums(existing_checksum_map: dict[str, str], dependencies: dict[str, list[str]]) -> bool:
    """Verify file checksums and execute scripts for changed dependencies.

    Compares current file checksums against stored checksums to detect changes.
    When changes are detected, executes all scripts that depend on the changed files.

    Args:
        existing_checksum_map: Dictionary mapping file paths to their stored checksums
        dependencies: Dictionary mapping file paths to lists of dependent scripts

    Returns:
        True if any checksums changed and checksum file needs refresh, False otherwise
    """
    checksum_refresh = False
    scripts_to_execute = set()

    for file_path, scripts in dependencies.items():
        with open(file_path, "rb") as dependency_file:
            file_bytes = dependency_file.read()
            current_hash = hashlib.sha256(file_bytes).hexdigest()

            if file_path not in existing_checksum_map or current_hash != existing_checksum_map[file_path]:
                logging.info("Hash mismatch detected: %s", file_path)
                checksum_refresh = True
                scripts_to_execute.update(scripts)
            else:
                logging.info("Hash matches: %s", file_path)

    # Execute all scripts that have dependency changes
    for script in scripts_to_execute:
        logging.info("Executing script: %s", script)
        run_file(script)

    return checksum_refresh


def main() -> None:
    """Main entry point for the dependency tracking script.

    Parses command line arguments, sets up logging, changes to the chezmoi
    source directory, loads existing checksums, checks dependencies, and
    updates checksums as needed.
    """
    parser = argparse.ArgumentParser(description="Monitor file dependencies and run associated scripts on changes.")
    parser.add_argument("--skip_install", action="store_true", help="Skip dependency checks and only update checksums")
    args = parser.parse_args()

    # Configure logging
    logging.basicConfig(
        format="%(asctime)s [%(levelname)-5.5s] [%(process)d] (%(name)s) %(message)s",
        level=logging.INFO,
    )

    # Determine chezmoi source directory
    # NOTE: When run from chezmoi, it sets the CHEZMOI_SOURCE_DIR environment variable
    source_directory = os.environ.get("CHEZMOI_SOURCE_DIR")
    if not source_directory:
        logging.info("CHEZMOI_SOURCE_DIR not set, using chezmoi command to determine source path")
        result = subprocess.run(
            ["chezmoi", "source-path"],
            check=True,
            capture_output=True,
            encoding="utf-8",
        )
        source_directory = result.stdout.strip()

    os.chdir(source_directory)

    # Load existing checksums from file
    existing_checksum_map: dict[str, str] = {}
    try:
        with open(CHECKSUM_FILE, encoding="utf-8") as checksum_file:
            for line in checksum_file:
                tokenized = line.strip().split(maxsplit=1)
                if len(tokenized) == 2:
                    existing_checksum_map[tokenized[1]] = tokenized[0]
    except FileNotFoundError:
        logging.info("Checksum file not found. Will create after processing.")

    # Process dependencies
    dependencies = get_dependencies()
    if args.skip_install:
        logging.info("Skipping dependency checks, forcing checksum update")
        checksum_refresh = True
    else:
        checksum_refresh = verify_checksums(existing_checksum_map, dependencies)

    # Update checksum file if any changes were detected
    if checksum_refresh:
        create_checksum_file(list(dependencies.keys()))


if __name__ == "__main__":
    main()
