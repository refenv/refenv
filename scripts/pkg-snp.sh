#!/usr/bin/env bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "# SNAP: install"

for FNAME in /tmp/pkgs/snp-inst*.txt; do
  if [ ! -e "$FNAME" ]; then
    echo "# SNAP: nothing to do"
    exit 0
  fi

  apt-get -yq install snapd

  IFS=$'\n'
  for SNAP in $(cat $FNAME); do
    eval "snap install $SNAP"
  done
done

echo "# SNAP: DONE"
