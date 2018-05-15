# miniature-journey

This repository contains tools for efficiently for producing and distributed
reference operating system environments for Open Source projects. The primary
tools utilized are qemu, packer, and vagrant wrapped in with a Makefile.

The environments produced are hosted in the Vagrant Cloud here:

https://app.vagrantup.com/safl

They are defined by the files in the `machines` folder, along with the magic
provided by packer, the scripts in `scripts` and misc. stuff found in the
`shared` folder.

## Building

If you want to build the environment yourself, then run:

```
make u1604-base u1604-mini u1604-wrks u1604-qatd
```

This will build the Ubuntu 16.04 based environments in the order listed, the
order is required as the build of *mini* depends on the output of *base*, and
the build of *wrks* and *qatd* depends on the out of *mini*.

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
make u1604
make u1804

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

# Download from the cloud

```bash
# Download u1604-qatd image version 1.8.26
wget https://app.vagrantup.com/safl/boxes/u1604-qatd/versions/1.8.26/providers/libvirt.box -O u1604-qatd.box
# Unpack it
```

# References

qemu
packer
vagrant
