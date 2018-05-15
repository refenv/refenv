# ctrl-pi

**THIS IS WIP**

# Usage

Common steps using this reference image:

* Physical Setup
 - Write `ctrl-pi.img` to SDHC card
 - Insert SDHC card in RPI3
 - Insert USB stick, formatted with ETX4 fs, into RPI3
 - Plug in Ethernet cable
 - Plug in USB UART cable: Connect RPI to UART PINS of CNEX device
 - Plug in micro-USB to power the RPI
* Configure hostname and storage
 - Change hostname
 - Transfer `nvm` user to external storage
 - Reboot
* Configure gitlab-runner
 - Install and register gitlab-runner
 - Reboot
* Verify it works as expected

## Change hostname

```bash
read -p "enter hostname: " HOSTNAME
hostname $HOSTNAME
echo "$HOSTNAME"                >  /etc/hostname
echo "127.0.0.1 localhost"      >  /etc/hosts
echo "127.0.1.1 $HOSTNAME"      >> /etc/hosts
```

## Mount external storage and move nvm user there install GitLab runner

Example; add an EXT4 formatted USB stick as external storage. Plug the USB stick
into the RPI then move the `nvm` user onto the drive:

```bash
# Create home on external media
mkdir -p /mnt/ext/home

# Move the `nvm` user to external media
usermod --home /mnt/ext/home/nvm --move-home nvm
```

## Install and register GitLab runner

The image already have the `gitlab-runner` binary on the system. We just need to
tell it which user to run as, where to store data, start the runner, and then
register it with the GitLab server.

```bash
# Install it
gitlab-runner install \
--user=nvm \
--working-directory=/mnt/ext/home/nvm

# Start it
gitlab-runner start

# Register it: see the documentation in `cijoe-refenv/GLRUNNER.md`
```

# Documentation

The `CIPI` image is based on the **minibian[2]** distribution released
2016-03-12.  Which, in turn, is a **raspbian**[3] derivative. The distribution
provides a minimal non-GUI Debian based Linux distribution.

The following documents the steps to recreate the `ctrl-pi.img` image in case it
is lost or for other reasons unavailable.

Run these commands in the top-level directory of the **refenv** repository.

Start by creating `ctrl-pi.img` based on **minibian** and defining some variables
to make the process easier:

```bash
IMG_FNAME=ctrl-pi.img
IMG_FPATH=/tmp/$IMG_FNAME
```

Download minibian from SourceForge:

```bash
# Download minibian
wget -qO- https://sourceforge.net/projects/minibian/files/2016-03-12-jessie-minibian.tar.gz/download | tar xvz -C /tmp

# Rename it to ctrl-pi
mv /tmp/2016-03-12-jessie-minibian.img $IMG_FPATH
```

Define additional variables used in the remaining configuration:

```bash
SECT_SIZE=512

BOOT_START=$(fdisk -l -o Start $IMG_FPATH | tail -2 | head -1)
BOOT_OFFSET=$(($SECT_SIZE * $BOOT_START))
BOOT_MP=/mnt/boot

USER_START=$(fdisk -l -o Start $IMG_FPATH | tail -1)
USER_OFFSET=$(($SECT_SIZE * $USER_START))
USER_MP=/mnt/user

# Create mountpoints
sudo mkdir -p $BOOT_MP
sudo mkdir -p $USER_MP
```

## Modify user space via qemu

Grow the image and second partition:

```bash
# Grow the file
qemu-img resize -f raw $IMG_FPATH $((1024*1024*1024*2))

# Grow the partition
# NOTE: if `growpart` is not available: sudo apt-get install cloud-guest-utils
growpart $IMG_FPATH 2

# Add qemu /etc/
sudo mount -v -o offset=$USER_OFFSET -t ext4 $IMG_FPATH $USER_MP
sudo cp -r systems/ctrl-pi/install/qemu/etc/* $USER_MP/etc/.
sudo umount $USER_MP
```

Emulate the RPI by executing the following:

```bash
# NOTE: if `qemu-system-arm` fails: sudo apt-get install qemu-system-arm
qemu-system-arm \
-kernel systems/ctrl-pi/install/rpi.kernel \
-cpu arm1176 \
-m 256 \
-M versatilepb \
-serial stdio \
-append "root=/dev/sda2 rootfstype=ext4 rw" \
-hda $IMG_FPATH \
-redir tcp:5022::22 \
-no-reboot
```

You can now log into the emulated RPI using login **root**/**raspberry**:

```bash
ssh -p 5022 root@localhost
```

Start by changing the password:

```bash
# Change password
passwd
```

And then perform the software package upgrade and install:

```bash
# Grow file system
resize2fs /dev/sda2

# Change hostname
hostname ctrl-pi
echo "ctrl-pi"                >  /etc/hostname
echo "127.0.0.1 localhost" >  /etc/hosts
echo "127.0.1.1 ctrl-pi"      >> /etc/hosts

# Create the `nvm` user
useradd \
--comment 'Non-Volatile Memory' \
--create-home \
--shell /bin/bash \
nvm

# Set a password for the `nvm` user
passwd nvm

# Create mointpoint for external storage
mkdir -p /mnt/ext

# Download gitlab-runner
wget -O /usr/local/bin/gitlab-runner \
https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-arm

# Make it executable
chmod +x /usr/local/bin/gitlab-runner

# Packages via APT
apt-get update -y && \
apt-get upgrade -y && \
apt-get install \
minicom \
vim-nox \
htop \
git \
python \
python-yaml \
python-jinja2 \
python-pip \
-y && \
apt-get clean -y && \
apt-get autoremove -y

# Packages via PIP
pip install ansi2html

# Shutdown
shutdown now
```

## Modify /etc for RPI3

Run the following commands:

```bash
# Mount the user partition
sudo mount -v -o offset=$USER_OFFSET -t ext4 $IMG_FPATH $USER_MP

# Install fstab, minicom setups, and ssh-config for users `root` and `nvm`
sudo cp -r systems/ctrl-pi/install/rpi3/etc/fstab $USER_MP/etc/
sudo cp -r shared/minicom/* $USER_MP/etc/minicom/

chmod 600 shared/dot.ssh/*
chmod 700 shared/dot.ssh

sudo cp -r shared/dot.ssh $USER_MP/root/.ssh
sudo cp -r shared/dot.ssh $USER_MP/home/nvm/.ssh
sudo chown -R 1000:1000 $USER_MP/home/nvm/.ssh

# Un-mount the boot partition
sudo umount $USER_MP
```

## Modify /boot for RPI3

Run the following commands:

```bash
# Mount the boot partition, overwrite configs, and unmount again
sudo mount -v -o offset=$BOOT_OFFSET -t vfat $IMG_FPATH $BOOT_MP
sudo cp -r systems/ctrl-pi/install/rpi3/boot/* $BOOT_MP/.
sudo umount $BOOT_MP
```

# References

* [1] https://azeria-labs.com/emulate-raspberry-pi-with-qemu/
* [2] https://minibianpi.wordpress.com/
* [3] https://www.raspberrypi.org/downloads/raspbian/
* [4] https://github.com/dhruvvyas90/qemu-rpi-kernel
