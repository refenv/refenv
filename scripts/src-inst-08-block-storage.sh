#!/usr/bin/env bash
#
# Installs block-storage SHA(f07780ea) from source into /opt/block-storage
#
set -e

NAME=block-storage
REPOS_URL=https://github.com/cloudharmony/block-storage.git
REPOS_PATH=/opt/$NAME
REPOS_TAG=f07780ea1dbdfd5b342627f9fbc3b8a9bc346aea

echo "# install '$NAME' from '$REPOS_URL'/'$REPOS_TAG' to '$REPOS_PATH'"

git clone $REPOS_URL $REPOS_PATH
cd $REPOS_PATH

git checkout .
git checkout $REPOS_TAG

echo "- {'name': '$NAME', 'tag': '$REPOS_TAG'}" >> /opt/ver.refenv.yml
echo "# DONE: '$NAME'"
