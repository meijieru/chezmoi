import glob
import logging
import os
import shutil

import yaml


def cleanup(config: dict, root_dir: str, use_trash: bool = True) -> None:
    def get_files(pattern):
        pattern_abs = os.path.join(os.path.expanduser(root_dir), pattern)
        return glob.glob(pattern_abs)

    files_to_delete = []
    for pattern in config["delete"]:
        files_to_delete.extend(get_files(pattern))
    if len(files_to_delete):
        logging.info("Delete: %s", files_to_delete)

    for fpath in files_to_delete:
        if not os.path.exists(fpath):
            continue

        if use_trash:
            os.system(f"trash-put {fpath}")
        elif os.path.isdir(fpath) and not os.path.islink(fpath):
            shutil.rmtree(fpath)
        else:
            os.remove(fpath)

    files_to_warn = []
    for pattern in config["check"]:
        files_to_warn.extend(get_files(pattern))
    if len(files_to_warn):
        logging.warning("Check: %s", files_to_warn)

    for pattern, dst in config["move"].items():
        src = get_files(pattern)
        if len(src) == 0:
            continue
        elif len(src) == 1:
            src = src[0]
        else:
            raise RuntimeError(f"{pattern} should not be pattern")

        dst = os.path.expandvars(dst)
        msg = f"{src} -> {dst}"
        if not os.path.isabs(dst):
            logging.warning("Skip %s, must be abs path", msg)
        elif os.path.exists(dst):
            logging.warning("Skip %s, dst exists", msg)
        else:
            logging.info("Renaming %s", msg)
            os.rename(src, dst)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Cleanup dir.")
    parser.add_argument(
        "--config_file",
        type=str,
        default="data/cleanup_homedir.yaml",
        help="config file",
    )
    parser.add_argument("--dir", type=str, default="~", help="dir to be cleaned")
    parser.add_argument("--log_level", type=str, default="info", help="log level")
    args = parser.parse_args()

    logging.basicConfig(
        format="%(asctime)s [%(levelname)-5.5s] [%(process)d] (%(name)s) %(message)s",
        level=getattr(logging, args.log_level.upper()),
    )

    with open(args.config_file) as f:
        config = yaml.load(f, Loader=yaml.SafeLoader)
    cleanup(config, args.dir)
