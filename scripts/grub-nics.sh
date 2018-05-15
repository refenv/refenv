#!/usr/bin/env bash

sed -i "s/GRUB_CMDLINE_LINUX=\".*\"/GRUB_CMDLINE_LINUX=\"biosdevname=0 net.ifnames=0\"/" /etc/default/grub
update-grub
