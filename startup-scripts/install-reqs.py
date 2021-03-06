#!/usr/bin/env python3
"""Redirect errors to log file, so we don't stop Jupyter from starting."""
import os
from os.path import join, exists
import subprocess

USER_VENV = os.environ["USER_VENV"]
NOTEBOOK_DIR = os.environ["NOTEBOOK_DIR"]
RESULTS_TXT = join(NOTEBOOK_DIR, "requirements-install-log.txt")
log = open(RESULTS_TXT, "w")
PIP = join(USER_VENV, "bin", "pip")
ERROR_LOG = join(NOTEBOOK_DIR, "ERRORS-FROM-REQUIREMENTS-INSTALL.txt")
REQS_TXT = join(NOTEBOOK_DIR, "requirements.txt")
REQS_PINNED = join(NOTEBOOK_DIR, "requirements.pinned.txt")

if exists(ERROR_LOG):
    os.remove(ERROR_LOG)


def run(*args):
    print("RUNNING", " ".join(args), "...")
    result = subprocess.run(args, stdout=log, stderr=log).returncode
    if result != 0:
        os.rename(RESULTS_TXT, ERROR_LOG)
        print("ERROR installing requirements.txt")
        log.close()
        raise SystemExit(0)
    print("SUCCEEDED")


# (Re-)pin dependencies in requirements.txt if it's new:
if not exists(REQS_PINNED) or (
    os.stat(REQS_TXT).st_mtime > os.stat(REQS_PINNED).st_mtime
):
    run("pip-compile", "-o", REQS_PINNED, REQS_TXT)

# Allow users to install packages, and in particular allow upgrades.
run(
    PIP, "install", "--upgrade", "-r", REQS_PINNED,
)

# Install the IPython kernel and Dotscience, the absolute minimum needed:
run(PIP, "install", "ipykernel", "dotscience")

# Make sure the IPython kernel is registered with Jupyter:
run(
    join(USER_VENV, "bin", "python"),
    "-m",
    "ipykernel",
    "install",
    "--user",
    "--name",
    "user-virtualenv",
    "--display-name",
    "Your custom Python 3",
)
log.close()
