#!/usr/bin/env bash
set -e

cd /tmp
rm -rf /tmp/repos-*
apt-get -yq autoremove
apt-get -yq clean
fstrim -av
