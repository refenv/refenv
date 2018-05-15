#!/usr/bin/env bash
#
# Installs blktests rev 5f2a8e98 from source into /opt/blktests
#
set -e

NAME=blktests
REPOS_URL=https://github.com/osandov/blktests.git
REPOS_PATH=$(mktemp -d -u --suffix=-$NAME -t repos-XXXXXX)
REPOS_TAG="5f2a8e98b163bab27d71b83e4db418e8672c9330"

echo "# install '$NAME' from '$REPOS_URL'/'$REPOS_TAG' to '$REPOS_PATH'"

git clone $REPOS_URL $REPOS_PATH
cd $REPOS_PATH

git checkout .
git checkout $REPOS_TAG

make clean
make

mv $REPOS_PATH /opt/$NAME

echo "- {'name': '$NAME', 'tag': '$REPOS_TAG'}" >> /opt/ver.refenv.yml
echo "# DONE: '$NAME'"
