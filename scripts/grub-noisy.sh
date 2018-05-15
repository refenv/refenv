#!/usr/bin/env bash

sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\".*\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
update-grub
