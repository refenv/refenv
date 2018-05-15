#!/usr/bin/env bash
echo "# APT (0/7): purge, update, upgrade, purge, install, clean"; sleep 1

export DEBIAN_FRONTEND=noninteractive

echo "# APT (1/7): update"; sleep 1
apt-get -yq update

echo "# APT (2/7): remove/purge 1/2"
for FPATH in /tmp/pkgs/apt-prge*.txt; do
  if [ ! -e "$FPATH" ]; then
    echo "# Nothing to purge -- skipping"
    break
  fi

  apt-get -yq --purge remove $(cat $FPATH | sort -u)
done

echo "# APT (3/7): upgrade"; sleep 1
apt-get -yq upgrade

echo "# APT (4/7): dist-upgrade"; sleep 1
apt-get -yq dist-upgrade

echo "# APT (5/7): install"; sleep 1
for FPATH in /tmp/pkgs/apt-inst*.txt; do
  if [ ! -e "$FPATH" ]; then
    echo "# Nothing to install -- skipping"
    break
  fi

  apt-get -yq install $(cat $FPATH | sort -u)
done

echo "# APT (6/7): autoremove"; sleep 1
apt-get -yq autoremove

echo "# APT (7/7): clean"; sleep 1
apt-get -yq clean

echo "# APT (7/7): DONE"; sleep 1
