# refenv

This repository contains tools for efficiently producing and distributing
reference operating system environments for Open Source projects. The primary
tools utilized are [Packer][packer], [QEMU][qemu], and [Vagrant][vagrant]
wrapped in a Makefile.

The environments produced are hosted in the [Vagrant Cloud][vagrant-cloud] here:

https://app.vagrantup.com/safl

They are defined by the files in the `machines` folder, along with the magic
provided by packer, the scripts in `scripts` and misc. stuff found in the
`shared` folder.

## Building

If you want to build the environment yourself, then run:

```
# Build Ubuntu 16.04 boxes
make pack-u1604

# Build Ubuntu 18.04 boxes
make pack-u1804
```

This will build Ubuntu based environments, these will be stored in the `build`
folder and named such as:

```
# Ubuntu 16.04
u1604-base
u1604-mini
u1604-wrks
u1604-qatd

# Ubuntu 18.04
u1804-base
u1804-mini
u1804-wrks
u1804-qatd
```

The `mini` is based on the `base`, `wrks` and `qatd` are based on `mini`.

## Uploading to Vagrant Cloud

Assign the environment variables:

```
VAGRANT_CLOUD_USERNAME
VAGRANT_CLOUD_TOKEN
```

To sensible values for your Vagrant Cloud login, then run:

```
make u1604-base upload-vcloud
```

To upload the `u1604-base` environment to the Vagrant Cloud.

## Maintenance

Make the machine changes, scripts, aux files, then:

```bash
# Bump up the version number on all machines
make bump

# Pack the reference environments
make pack-u1604
make pack-u1804

# Upload them to the cloud
make u1604-base upload-vcloud
make u1604-mini upload-vcloud
make u1604-wrks upload-vcloud
make u1604-qatd upload-vcloud

# Upload them to the cloud
make u1804-base upload-vcloud
make u1804-mini upload-vcloud
make u1804-wrks upload-vcloud
make u1804-qatd upload-vcloud
```

NOTE: You should not bump the version or upload to the cloud until the
environments have been verified locally.

# Manually download Vagrant Boxes from Vagrant Cloud

```bash
# Download u1604-qatd image version 1.8.35
wget https://app.vagrantup.com/safl/boxes/u1604-qatd/versions/1.8.35/providers/libvirt.box -O u1604-qatd.box
```

# Manually Unpack `qcow2` images from Vagrant Boxes

Extract the qemu qcow2 image from the Vagrant Box, e.g. extract it from the
u1604-base.box:

```bash
# Extract it
tar xzvf u1604-base.box box.img -C u1604-base.qcow2

# Rename it
mv box.img u1604-base.qcow2
```

Once extracted from the Vagrant box you can do a couple of things.

## Write `qcow2` image to a physical device

Provision a physical machine using the reference image, e.g. write it to the
device named `sdc`:

```bash
qemu-img convert -f qcow2 -O raw -p u1604-base.qcow2 /dev/sdc
```

## Inspect `qcow2` image meta-data

Have a look at the meta-data:

```bash
qemu-img info u1604-base.qcow2
```

It should output information such as:

```
image: u1604-base.qcow2
file format: qcow2
virtual size: 10G (10737418240 bytes)
disk size: 3.3G
cluster_size: 65536
Format specific information:
    compat: 1.1
    lazy refcounts: false
    refcount bits: 16
    corrupt: false
```

# References

* [qemu][qemu]
* [qemu-img][qemu-img]
* [packer][packer]
* [vagrant][vagrant]
* [vagrant-cloud][vagrant-cloud]

[qemu]: https://www.qemu.org/
[qemu-img]: https://qemu.weilnetz.de/doc/qemu-doc.html#qemu_005fimg_005finvocation
[packer]: https://www.packer.io/
[vagrant]: https://www.vagrantup.com/
[vagrant-cloud]: https://app.vagrantup.com/
