#!/usr/bin/env bash

JAZZ=$PWD

cd /tmp && \
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-headers-4.10.0-041000_4.10.0-041000.201702191831_all.deb && \
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-headers-4.10.0-041000-generic_4.10.0-041000.201702191831_amd64.deb && \
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-image-4.10.0-041000-generic_4.10.0-041000.201702191831_amd64.deb && \
dpkg -i linux*.deb && \
cd $JAZZ; echo "# res: $?"

