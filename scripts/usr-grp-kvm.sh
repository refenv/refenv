#!/usr/bin/env bash
set -e

DEFAULT_USERNAME=odus

USERNAME=$1
if [ -z "$USERNAME" ]; then
  USERNAME=$DEFAULT_USERNAME
fi

usermod -aG kvm $USERNAME
