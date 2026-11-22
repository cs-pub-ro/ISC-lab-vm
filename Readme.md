# ISC Lab virtual machine source code

This repository contains the ISC Lab VM generation scripts, based on 
[LabVM Framework](https://github.com/cs-pub-ro/labvm-framework)
(automated using `qemu` and Packer).

Requirements:
 - a modern Linux system;
 - basic build tools (make);
 - [Hashicorp's Packer](https://packer.io/);
 - [qemu+kvm](https://qemu.org/);

## Preparation

Download and save a [Debian 13 netinst
install](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/) iso image
(or change `base-ver` in the Makefile to another distro version).

Optionally, create `config.local.mk`, copy the variables from
[`config.sample.mk`](https://github.com/cs-pub-ro/ISC-lab-vm/blob/master/config.sample.mk) and/or [`framework/config.default.mk`](https://github.com/cs-pub-ro/labvm-framework/blob/master/config.default.mk)
and edit them to your liking.

You might also want to ensure that packer and qemu are properly installed and
configured.

## Building the VM

The following Makefile goals are available (the build process is usually in this
order):

- `base`: builds a base Debian 13 install (required for the VM image);
- `labvm`: builds the Lab VM with all required scripts and config;
- `localvm`: exports the `labvm` VM to VirtualBox/VMware (`.vmdk`/`.ovf`);
- `cloud`: builds (from `labvm` VM) the cloud VM, cleaned up and ready
  for cloud usage (e.g., AWS, OpenStack).
- `labvm_edit`: easily edit an already build Lab VM (uses the previous
  image as backing snapshot);
- `labvm_commit`: commits the edited VM back to its backing base;
- `[*]_clean`: removes the generated image(s);
- `ssh`: SSH-es into a running Packer VM;

If packer complains about the output file existing, use the `_clean` goal (or
`FORCE=1` to wipe the destination before building):
```sh
make labvm_clean labvm
```

If you want to keep the install scripts at the end of the provisioning phase,
set the `DEBUG` variable. Also check out `PAUSE` (it pauses packer,
letting you inspect the VM inside qemu):
```sh
make PAUSE=1 DEBUG=1 labvm labvm_edit
```

Read [https://github.com/cs-pub-ro/labvm-framework|LabVM Framework's]
documentation for more lower-level targets and options.

