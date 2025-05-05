# Fabric uses paramiko, which has inbuilt logging avaialable
import logging
import argparse
import datetime as dt
from python_proj.custom_logging import init_logger
from python_proj.misc import (
    bcolors,
    phead,
    plog,
    pnorm,
    pwarn,
    pquit,
    readConfig,
    createDir,
    createCurDir,
    cleanDir,
)


def makeArgs() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="main.py",
        description="Program allowing execution of arbitrary commands and result collection from remote SSH hosts.",
    )

    parser.add_argument(
        "-d",
        "--directory",
        default="data",
        help="Location of output files.",
    )

    parser.add_argument(
        "-d",
        "--debug",
        help="Enables debug output.",
        action="store_true",
    )
    return parser.parse_args()


if __name__ == "__main__":
    args = makeArgs()
    plog(args)

    logger = init_logger(args.debug)

    # Write time to both streams to distinguish runs in log files
    pnorm(f"TIME: Started at {dt.datetime.now()}")
    pwarn(f"TIME: Started at {dt.datetime.now()}")

    phead("Done!")
