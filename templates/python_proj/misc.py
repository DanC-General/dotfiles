"""
Contains miscellanous functions for performing non-specific tasks.
"""

import os
import sys
import json
import yaml
import signal
import hashlib
import logging
import datetime as dt

logger = logging.getLogger(__name__)

# Handle Ctrl^C


def exit_graceful(sig, fname):
    pwarn("Ctrl^C pressed: quitting...")
    sys.stdout.flush()
    sys.stdin.flush()
    os.system("stty sane")  # Reset terminal state
    sys.exit(0)


signal.signal(signal.SIGINT, exit_graceful)


# Message Colouring


class bcolors:
    HEADER = "\033[95m"
    OKBLUE = "\033[94m"
    LIGHTBLUE = "\033[38;5;110m"
    OKCYAN = "\033[96m"
    OKGREEN = "\033[92m"
    WARNING = "\033[93m"
    FAIL = "\033[91m"
    ENDC = "\033[0m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"


def makeColoured(msg: str, col: bcolors) -> str:
    return f"{col}{msg}{bcolors.ENDC}"


def perr(msg: str):
    logger.error(f"{msg}")


def pquit(msg: str):
    perr(f"{msg}")
    exit(1)


def pwarn(msg: str):
    logger.warning(f"{msg}")


def phead(msg: str):
    pnorm(f"\n{msg}\n", bcolors.HEADER)


def pnorm(msg: str, col: bcolors = bcolors.OKGREEN):
    logger.info(f"{msg}", extra={"prefix": col})


def plog(msg: str):
    logger.debug(f"{msg}")


# File readers


def readYaml(file_path: str):
    if not checkFile(file_path):
        pquit(f"YAML file {file_path} does not exist.")

    with open(file_path, "r") as f:
        try:
            return yaml.safe_load(f)
        except yaml.YAMLError as exc:
            pquit(f"YAML file {file_path} was invalid: {exc}")


def readJson(file_path: str):
    if not checkFile(file_path):
        pquit(f"JSON file {file_path} does not exist.")

    with open(file_path, "r") as f:
        return json.load(f)


def readConfig(config_file: str) -> dict:
    ext_actions = {"yaml": readYaml, "json": readJson}
    if not checkFile(config_file):
        pquit(f"Provided configuration file {config_file} does not exist.")

    config_ext = config_file.split(".")[-1]
    if config_ext not in ext_actions:
        pquit(
            f"Unsupported config file extension {config_ext} from {
            [i for i in ext_actions.keys()]}."
        )

    return ext_actions[config_ext](config_file)


# Validation


def checkDir(dir_path: str):
    if not os.path.isdir(dir_path):
        pwarn(f"Path {dir_path} is invalid")
        return False
    return True


def checkFile(file_path: str):
    if not os.path.isfile(file_path):
        pwarn(f"Path {file_path} is invalid")
        return False
    return True


def createDir(dir_name: str) -> str:
    """
    Create a directory by name if it doesn't exist.
    """
    if not os.path.exists(dir_name):
        pwarn(f"Created new directory at {dir_name}")
        os.makedirs(dir_name)

    return dir_name


def createCurDir(dir_name: str) -> str:
    """
    Create a directory in the same place as the executing python file, instead of the
        current terminal working directory.
    """
    current_directory = os.path.dirname(os.path.abspath(__file__))
    new_directory = os.path.join(current_directory, dir_name)

    return createDir(new_directory)


# File handlers


def cleanDir(target_dir: str):
    if checkDir(target_dir):
        for entry in os.scandir(target_dir):
            if entry.is_dir() and len([sd for sd in os.scandir(entry.path)]) == 0:
                pwarn(f"Cleanup - Removing empty dir {entry.path}")
                os.rmdir(entry.path)


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    if not True:
        logging.disable(logging.CRITICAL + 1)
