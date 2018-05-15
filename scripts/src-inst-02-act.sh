#!/usr/bin/env bash
#
# Installs Aerospike Certification Toolsbox (ACT) SHA(f07780ea) from source into
# /opt/act
#
set -e

NAME=act
REPOS_URL=https://github.com/aerospike/act.git
REPOS_PATH=/opt/$NAME
REPOS_TAG=1ea3e67a182226b30ca621713cc020a248768386

echo "# install '$NAME' from '$REPOS_URL'/'$REPOS_TAG' to '$REPOS_PATH'"

git clone $REPOS_URL $REPOS_PATH
cd $REPOS_PATH

git checkout .
git checkout $REPOS_TAG

make
make -f Makesalt

echo "- {'name': '$NAME', 'tag': '$REPOS_TAG'}" >> /opt/ver.refenv.yml
echo "# DONE: '$NAME'"
