#!/usr/bin/env bash
#
# Installs SPDK tagged v18.04 from source into /opt/spdk
#
set -e

NAME=spdk
REPOS_URL=https://github.com/spdk/spdk.git
REPOS_PATH=$(mktemp -d -u --suffix=-$NAME -t repos-XXXXXX)
REPOS_TAG="v18.07"

echo "# install '$NAME' from '$REPOS_URL' via '$REPOS_PATH'"

git clone $REPOS_URL $REPOS_PATH
cd $REPOS_PATH

echo "# NAME: '$NAME' REPOS_TAG: '$REPOS_TAG'"
OPT_PATH=/opt/$NAME

git checkout .
git checkout $REPOS_TAG

make clean
git submodule update --init
./scripts/pkgdep.sh
make clean
./configure --prefix=$OPT_PATH
make

cp -r $REPOS_PATH/. $OPT_PATH/

echo "- {'name': '$NAME', 'tag': '$REPOS_TAG'}" >> /opt/ver.refenv.yml
echo "# DONE: '$NAME'"
