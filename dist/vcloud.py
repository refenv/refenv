#!/usr/bin/env python
import subprocess
import requests
import pprint
import json
import sys
import os

VCLOUD_API = "https://app.vagrantup.com/api/v1/"

PARAMS = [
    "VAGRANT_CLOUD_TOKEN",
    "VAGRANT_CLOUD_USERNAME",
    "MACHINE_NAME",
    "MACHINE_VERS",
    "MACHINE_VER_MAJOR",
    "MACHINE_VER_MINOR",
    "MACHINE_VER_PATCH",
    "MACHINE_BOX_PATH",
    "MACHINE_UPLOAD_URI",
    "MACHINE_BOX_PROVIDER"
]

def vcapi(cfg=None, target=None, payload=None, hdrs=None):
    """Send a request to the Vagrant CLOUD API"""


    if hdrs is None:
        hdrs = {}

    if "Content-Type" not in hdrs:
        hdrs["Content-Type"] = "application/json"

    url = "/".join([VCLOUD_API, target])
    hdrs.update({
        "Authorization": "Bearer %s" % cfg["VAGRANT_CLOUD_TOKEN"]
    })

    if payload is None:
        res = requests.get(url, headers=hdrs)
    else:
        res = requests.post(url, headers=hdrs, data=json.dumps(payload))

    return res.status_code, json.loads(res.text)

def vcapi_auth(cfg):
    """Try authenticating with the Vagrant Cloud"""

    return vcapi(cfg, "authenticate")

def vcapi_box_add(cfg):
    """Create a new box"""

    payload = {
        "box": {
            "username": cfg["VAGRANT_CLOUD_USERNAME"],
            "name": cfg["MACHINE_NAME"]
        }
    }

    return vcapi(cfg, "boxes", payload)

def vcapi_box_version_add(cfg):
    """Create a new version"""

    target = "/".join([
        "box", cfg["VAGRANT_CLOUD_USERNAME"], cfg["MACHINE_NAME"], "versions"]
    )

    payload = {
        "version": {
            "version": cfg["MACHINE_VERS"],
        }
    }

    return vcapi(cfg, target, payload)

def vcapi_box_version_provider_add(cfg):
    """Create a new version"""

    target = "/".join([
        "box", cfg["VAGRANT_CLOUD_USERNAME"], cfg["MACHINE_NAME"], "version",
        cfg["MACHINE_VERS"], "providers"
    ])

    payload = {
        "provider": {
            "name": cfg["MACHINE_BOX_PROVIDER"],
        }
    }

    return vcapi(cfg, target, payload)

def vcapi_box_version_provider_uri(cfg):
    """Get an URI for the provider for upload"""

    target = "/".join([
        "box", cfg["VAGRANT_CLOUD_USERNAME"], cfg["MACHINE_NAME"], "version",
        cfg["MACHINE_VERS"], "provider", cfg["MACHINE_BOX_PROVIDER"], "upload"
    ])

    scode, data = vcapi(cfg, target)

    cfg["MACHINE_UPLOAD_URI"] = data["upload_path"]

    return scode, data

def vcapi_box_version_provider_upload(cfg):
    """Upload a box"""

    cmd = [
        "curl", cfg["MACHINE_UPLOAD_URI"],
        "--request", "PUT",
        "--upload-file", os.sep.join(["build", "%s.box" % cfg["MACHINE_NAME"]])
    ]

    proc = subprocess.Popen(cmd)
    stdout, stderr = proc.communicate()

    return proc.returncode, {}

def main():
    """bla"""

    cfg = {param: os.environ.get(param) for param in PARAMS}

    if cfg["MACHINE_VERS"] is None:
        cfg["MACHINE_VERS"] = "v%s.%s.%s" % (
            cfg["MACHINE_VER_MAJOR"],
            cfg["MACHINE_VER_MINOR"],
            cfg["MACHINE_VER_PATCH"]
        )

    tasks = [
        ("auth", vcapi_auth),
        ("box_add", vcapi_box_add),
        ("box_version_add", vcapi_box_version_add),
        ("box_version_provider_add", vcapi_box_version_provider_add),
        ("box_version_provider_uri", vcapi_box_version_provider_uri),
        ("box_version_provider_upload", vcapi_box_version_provider_upload)
    ]

    for label, func in tasks:
        scode, data = func(cfg)
        print("# %s " % label)
        pprint.pprint(data)

    return 0

if __name__ == "__main__":
    sys.exit(main())
