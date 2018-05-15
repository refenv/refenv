#!/usr/bin/env bash
set -e

NAME=packer
REPOS_TAG=1.2.4

echo "# installing: packer"
mkdir -p $HOME/.local/bin && \
wget https://releases.hashicorp.com/packer/${REPOS_TAG}/packer_${REPOS_TAG}_linux_amd64.zip -O /tmp/packer.zip && \
unzip /tmp/packer.zip -d /tmp && \
cp /tmp/packer /usr/local/bin/

echo "# done: packer-install: $?"

echo "- {'name': '$NAME', 'tag': '$REPOS_TAG'}" >> /opt/ver.refenv.yml
