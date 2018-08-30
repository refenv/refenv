#!/usr/bin/env bash
#
# Installs SPDK tagged v18.07 from source into /opt/spdk
#
set -e

NAME=spdk
REPOS_URL=https://github.com/spdk/spdk.git
OPT_PATH=/opt/$NAME
REPOS_PATH=$OPT_PATH
REPOS_TAG="v18.07"

echo "# NAME: '$NAME' REPOS_TAG: '$REPOS_TAG'"
echo "# install '$NAME' from '$REPOS_URL' via '$REPOS_PATH'"

git clone $REPOS_URL $REPOS_PATH
cd $REPOS_PATH

git checkout .
git checkout $REPOS_TAG

git submodule update --init
./scripts/pkgdep.sh

./configure
make -j $(nproc)
make install

cd dpdk
make install

echo "- {'name': '$NAME', 'tag': '$REPOS_TAG'}" >> /opt/ver.refenv.yml
echo "# DONE: '$NAME'"
