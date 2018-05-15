#!/usr/bin/env bash
set -e

echo "# swapfile"

fallocate -l 512MiB /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
swapon --show

cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

echo "# swapfile: DONE"
