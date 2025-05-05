import os
import sys
import logging
from python_proj.misc import bcolors, pwarn, createCurDir

# Set up logging

# LOGS_ENABLED = False

logger = logging.getLogger(__name__)


class CustomFormatter(logging.Formatter):
    """Custom formatter to change log message per level."""

    FORMATS = {
        logging.DEBUG: bcolors.LIGHTBLUE + "[DEBUG] %(message)s" + bcolors.ENDC,
        logging.INFO: "%(prefix)s%(message)s" + bcolors.ENDC,
        logging.WARNING: "\n"
        + bcolors.WARNING
        + "[WARNING] %(message)s"
        + bcolors.ENDC
        + "\n",
        logging.ERROR: "\n"
        + bcolors.FAIL
        + "[ERROR] %(message)s"
        + bcolors.ENDC
        + "\n",
        logging.CRITICAL: "[CRITICAL] %(message)s" + bcolors.ENDC,
    }

    def format(self, record):
        log_fmt = self.FORMATS.get(record.levelno, "%(message)s")
        formatter = logging.Formatter(log_fmt)
        return formatter.format(record)


# def enable_logging():
#     global LOGS_ENABLED
#     LOGS_ENABLED = True


def make_logger():
    logger = logging.getLogger("custom_logger")
    logger.setLevel(logging.DEBUG)

    # Create console handler
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(CustomFormatter())
    return logger


def init_logger(debug_on: bool):
    # Handler for stdout (DEBUG & INFO)
    stdout_handler = logging.StreamHandler(sys.stdout)
    stdout_handler.setLevel(logging.DEBUG)  # Capture DEBUG and above
    stdout_handler.setFormatter(CustomFormatter())
    stdout_handler.addFilter(lambda record: record.levelno < logging.WARNING)

    # Handler for stderr (WARNING & above)
    stderr_handler = logging.StreamHandler(sys.stderr)
    stderr_handler.setLevel(logging.WARNING)  # Capture WARNING, ERROR, CRITICAL
    stderr_handler.setFormatter(CustomFormatter())

    # Make log directory if it doesn't exist
    logs_directory = createCurDir(f"logs")

    # Don't write colour to log files - difficult to read
    # Also write stderr to log file
    stderr_file_handler = logging.FileHandler(f"{logs_directory}/stderr.log")
    stderr_file_handler.setLevel(logging.WARNING)  # Capture WARNING, ERROR, CRITICAL
    stderr_file_handler.setFormatter(
        logging.Formatter("[%(levelname)s] %(asctime)s: %(message)s")
    )

    # Also write stdout to separate log file
    stdout_file_handler = logging.FileHandler(f"{logs_directory}/stdout.log")
    stdout_file_handler.setLevel(logging.DEBUG)  # Capture DEBUG and above
    stdout_file_handler.addFilter(lambda record: record.levelno < logging.WARNING)
    stdout_file_handler.setFormatter(
        logging.Formatter("[%(levelname)s] %(asctime)s: %(message)s")
    )

    # Configure root logger
    if debug_on:
        logging.basicConfig(
            level=logging.DEBUG,
            handlers=[
                stdout_handler,
                stderr_handler,
                stderr_file_handler,
                stdout_file_handler,
            ],
        )
    else:
        # Still write debug messages to log file, just not terminal
        stdout_handler.setLevel(logging.INFO)
        logging.basicConfig(
            level=logging.DEBUG,
            handlers=[
                stdout_handler,
                stderr_handler,
                stderr_file_handler,
                stdout_file_handler,
            ],
        )
    return logging.getLogger(__name__)
