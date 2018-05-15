#!/usr/bin/env bash

DEV_NAME=$MOD_DEV_NAME
PART_NUM=$MOD_PART_NUM

if [[ -z "$DEV_NAME" ]]; then
  DEV_NAME="vda"
fi

if [[ -z "$PART_NUM" ]]; then
  PART_NUM="1"
fi

growpart /dev/${DEV_NAME} ${PART_NUM} || true
resize2fs /dev/${DEV_NAME}${PART_NUM}
