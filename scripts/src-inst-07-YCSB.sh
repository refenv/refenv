#!/usr/bin/env bash
#
# Installs YCSB 0.12.0 from release into /opt/ycsb
#
set -e

NAME=ycsb

REL_VER=0.12.0
REL_NAME=$NAME-$REL_VER
REL_FNAME=$REL_NAME.tar.gz
REL_URL=https://github.com/brianfrankcooper/YCSB/releases/download/$REL_VER/$REL_FNAME
REL_PATH=$(mktemp -d -u --suffix=-$NAME -t rel-XXXXXX)

echo "# install '$NAME' from '$REL_URL' via '$REL_PATH'"

mkdir -p $REL_PATH
cd $REL_PATH
wget $REL_URL -O $REL_FNAME
tar xzf $REL_FNAME
mv $REL_NAME /opt/YCSB

echo "- {'name': '$NAME', 'tag': '$REL_VER'}" >> /opt/ver.refenv.yml
echo "# DONE: '$NAME'"
