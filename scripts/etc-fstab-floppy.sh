#!/usr/bin/env bash
set -e

echo "# commenting out fstab floppy entry"

sed -e '/floppy/ s/^#*/#/' -i /etc/fstab

echo "# DONE"
