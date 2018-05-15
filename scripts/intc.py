#!/usr/bin/env python
"""
    Integrity checker for machine definitions
"""
import argparse
import logging
import copy
import json
import sys
import os

MACHINE_DLAYOUT = {
    "pkgs": os.path.isdir,
    "tmpl.json": os.path.isfile
}

MACHINE = {
    "good": False,
    "name": None,
    "tmpl_fpath": None,
    "tmpl": None,
}

def expand_path(path):
    """Expands variables and assigns absolute of the given path"""

    return os.path.abspath(os.path.expanduser(os.path.expandvars(path)))

def machine_from_path(machine_path):
    """Load machine info from the given path"""

    try:
        machine = copy.deepcopy(MACHINE)
        machine["name"] = os.path.basename(machine_path)
        machine["tmpl_fpath"] = os.sep.join([machine_path, "tmpl.json"])
        machine["tmpl"] = json.load(open(machine["tmpl_fpath"]))
        machine["good"] = True
    except StandardError as exc:
        logging.info("machine_path: %r, exc: %r", machine_path, exc)

    return machine

def machines_from_path(path):
    """Load all machines found in the given path"""

    machines = {}

    for name in os.listdir(path):
        mpath = os.sep.join([path, name])
        if not os.path.isdir(mpath):
            continue

        machines[name] = machine_from_path(mpath)

    return sorted(machines.keys()), machines

def main(args):
    """Entry point"""

    names, machines = machines_from_path(args.path)

    ngood = sum([int(machines[m]["good"]) for m in machines])
    nbad = len(names) - ngood

    logging.info("res { ngood: %r, nbad: %r }", ngood, nbad)

    return 1 if nbad else 0


if __name__ == "__main__":

    PRSR = argparse.ArgumentParser(
        description="Check the integrity of all or a single machine definition"
    )
    PRSR.add_argument(
        "path",
        help='path to folder containing machine definitions'
    )
    PRSR.add_argument(
        "--machine",
        help="name of a single machine"
    )
    PRSR.add_argument(
        "--log-level",
        choices=[logging.DEBUG, logging.INFO, logging.ERROR],
        default=logging.DEBUG
    )

    ARGS = PRSR.parse_args()
    ARGS.path = expand_path(ARGS.path)

    logging.basicConfig(level=ARGS.log_level)

    RES = main(ARGS)
    sys.exit(RES)
