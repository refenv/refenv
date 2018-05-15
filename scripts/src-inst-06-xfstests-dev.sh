#!/usr/bin/env bash
#
# Installs xfstests-dev SHA(625515d6) from source into system paths
#
set -e

NAME=xfstests-dev
REPOS_URL=https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
REPOS_PATH=$(mktemp -d -u --suffix=-$NAME -t repos-XXXXXX)
REPOS_TAG=aefa9118349461de55013dc1abb828790b1da272

echo "# install '$NAME' from '$REPOS_URL'/'$REPOS_TAG' to '$REPOS_PATH'"

git clone $REPOS_URL $REPOS_PATH
cd $REPOS_PATH

git checkout .
git checkout $REPOS_TAG

make clean
make
make install
make install-dev

echo "- {'name': '$NAME', 'tag': '$REPOS_TAG'}" >> /opt/ver.refenv.yml
echo "# DONE: '$NAME'"
