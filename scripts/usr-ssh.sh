#!/usr/bin/env bash
set -e

DEFAULT_USERNAME=odus
USERNAME=$1
if [ -z "$USERNAME" ]; then
  USERNAME=$DEFAULT_USERNAME
fi

ROOT_SSH_PATH=/root/.ssh
USER_SSH_PATH=/home/${USERNAME}/.ssh

for SSH_PATH in "$ROOT_SSH_PATH" "$USER_SSH_PATH"; do
  mkdir -p $SSH_PATH
  cp -r /tmp/shared/dot.ssh/. $SSH_PATH/
  chmod -R 700 $SSH_PATH/
  chmod -R 644 $SSH_PATH/*.pub
  chmod -R 644 $SSH_PATH/authorized_keys
  chmod -R 600 $SSH_PATH/id_rsa
done

chown -R root:root $ROOT_SSH_PATH
chown -R $USERNAME:$USERNAME $USER_SSH_PATH
