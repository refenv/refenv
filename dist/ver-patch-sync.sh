#!/usr/bin/env bash

MACHINE_VER_PATCH=$1
if [[ -z "$MACHINE_VER_PATCH" ]]; then
  echo "usage: $0 VER_PATCH"
  exit 1
fi

echo "# MACHINE_VER_PATH: '${MACHINE_VER_PATCH}'"
for MACHINE_NAME in $(ls machines | sort); do
  echo ${MACHINE_VER_PATCH} > machines/${MACHINE_NAME}/ver.patch
done
