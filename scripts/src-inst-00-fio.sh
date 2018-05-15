#!/usr/bin/env bash
#
# Installs fio tagged fio-3.5 from source into system paths,
# and additionally into:
#
# /opt/fio-2.2.8
# /opt/fio-2.2.10
#
set -e

NAME=fio
REPOS_URL=https://github.com/axboe/fio.git
REPOS_PATH=$(mktemp -d -u --suffix=-$NAME -t repos-XXXXXX)
REPOS_TAGS="fio-2.2.8 fio-2.2.10 fio-3.5"
REPOS_TAGS_SYSINSTALL="fio-3.5"

echo "# install '$NAME' from '$REPOS_URL' via '$REPOS_PATH'"

git clone $REPOS_URL $REPOS_PATH
cd $REPOS_PATH

for REPOS_TAG in $REPOS_TAGS; do
  echo "# NAME: '$NAME' REPOS_TAG: '$REPOS_TAG'"
  OPT_PATH=/opt/$REPOS_TAG

  git checkout .
  git checkout $REPOS_TAG

  # Apply fixes
  if [ $REPOS_TAG == "fio-2.2.8" ]; then
    sed -i '27i#include <stdint.h>' lib/libmtd_legacy.c
  fi
  if [ $REPOS_TAG == "fio-2.2.10" ]; then
    sed -i '27i#include <stdint.h>' lib/libmtd_legacy.c
  fi

  make clean
  if [ "$REPOS_TAG" == "$REPOS_TAGS_SYSINSTALL" ]; then
    ./configure
  else
    ./configure --prefix=$OPT_PATH
  fi
  make
  make install

  echo "- {'name': '$NAME', 'tag': '$REPOS_TAG'}" >> /opt/ver.refenv.yml
done

echo "# DONE: '$NAME'"
