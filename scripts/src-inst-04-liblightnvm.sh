#!/usr/bin/env bash
#
# Installs liblightnvm from master into system paths
#
set -e

NAME=liblightnvm
REPOS_URL=https://github.com/OpenChannelSSD/liblightnvm.git
REPOS_PATH=$(mktemp -d -u --suffix=-$NAME -t repos-XXXXXX)
REPOS_TAG="v0.1.7"

echo "# install '$NAME' from '$REPOS_URL'/'$REPOS_TAG' to '$REPOS_PATH'"

git clone $REPOS_URL $REPOS_PATH
cd $REPOS_PATH

git checkout .
git checkout $REPOS_TAG

make clean cli_on tests_on examples_on ioctl_on lbd_off spdk_off debug_off deb_on configure build
make install-deb

echo "- {'name': '$NAME', 'tag': '$REPOS_TAG'}" >> /opt/ver.refenv.yml
echo "# DONE: '$NAME'"
