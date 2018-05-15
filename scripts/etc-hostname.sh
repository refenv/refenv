#!/usr/bin/env bash
set -e

if [[ -z "$MOD_HOSTNAME" ]]; then
  echo "# usage: MOD_HOSTNAME='new_hostname' ./etc-hostname.sh"
  exit 1
fi

hostname $MOD_HOSTNAME
echo "$MOD_HOSTNAME" >  /etc/hostname
sed -i "s/127.0.1.1.*/127.0.1.1\t$MOD_HOSTNAME/" /etc/hosts
