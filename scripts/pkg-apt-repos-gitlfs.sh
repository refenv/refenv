#!/usr/bin/env bash

apt-get -yq install software-properties-common curl && \
curl -sL https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
apt-get -yq update && \
echo "# DONE"; echo "# RES: $?"
