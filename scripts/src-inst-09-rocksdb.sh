#!/usr/bin/env bash
#
# Installs the db_bench tools from RocksDB TAG(v5.4.6_ocssd) into /opt/rocksdb
#
set -e

NAME=rocksdb
REPOS_URL=https://github.com/OpenChannelSSD/rocksdb.git
REPOS_PATH=$(mktemp -d -u --suffix=-$NAME -t repos-XXXXXX)
REPOS_TAG="v5.4.6_ocssd_v0.1.7"

OPT_PATH=/opt/$NAME

echo "# install '$NAME' from '$REPOS_URL'/'$REPOS_TAG' to '$REPOS_PATH'"

git clone $REPOS_URL $REPOS_PATH
cd $REPOS_PATH

git checkout .
git checkout $REPOS_TAG

# Build RocksDB library and db_bench
make clean
EXTRA_LDFLAGS="-fopenmp" EXTRA_CFLAGS="-fopenmp" EXTRA_CXXFLAGS="-fopenmp -fpermissive" DEBUG_LEVEL=0 /usr/bin/time make static_lib db_bench -j $(nproc) || true

# Install RocksDB library and db_bench
mkdir -p $OPT_PATH
INSTALL_PATH=$OPT_PATH make install

mv $REPOS_PATH/db_bench $OPT_PATH/

echo "- {'name': '$NAME', 'tag': '$REPOS_TAG'}" >> /opt/ver.refenv.yml
echo "# DONE: '$NAME'"
