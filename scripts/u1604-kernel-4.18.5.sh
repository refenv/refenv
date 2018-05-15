#!/usr/bin/env bash

JAZZ=$PWD

cd /tmp && \
wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4.1_amd64.deb && \
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.18.5/linux-headers-4.18.5-041805_4.18.5-041805.201808241320_all.deb && \
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.18.5/linux-headers-4.18.5-041805-generic_4.18.5-041805.201808241320_amd64.deb && \
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.18.5/linux-image-unsigned-4.18.5-041805-generic_4.18.5-041805.201808241320_amd64.deb && \
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.18.5/linux-modules-4.18.5-041805-generic_4.18.5-041805.201808241320_amd64.deb && \
dpkg -i libssl*.deb && \
dpkg -i linux*.deb && \
cd $JAZZ; echo "# res: $?"
