#!/usr/bin/env bash
#
# Installs nvme-cli TAG(v1.6) from source into system path
#
set -e

NAME=nvme-cli
REPOS_URL=https://github.com/linux-nvme/nvme-cli.git
REPOS_PATH=$(mktemp -d -u --suffix=-$NAME -t repos-XXXXXX)
REPOS_TAG="v1.6"

echo "# install '$NAME' from '$REPOS_URL'/'$REPOS_TAG' to '$REPOS_PATH'"

git clone $REPOS_URL $REPOS_PATH
cd $REPOS_PATH

git checkout .
git checkout $REPOS_TAG

make clean
make
make install

echo "- {'name': '$NAME', 'tag': '$REPOS_TAG'}" >> /opt/ver.refenv.yml
echo "# DONE: '$NAME'"
