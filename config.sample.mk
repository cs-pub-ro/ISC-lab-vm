# Sample VM build script config
# also check out framework/config.default.mk for all variables.

# Lab VM edition
ISC_LABVM_VERSION = 2023

# Base OS installation .iso image
BASE_VM_INSTALL_ISO ?= $(HOME)/Downloads/ubuntu-22.04.3-live-server-amd64.iso

# E.g., move build output (VM destination) directory to an external drive
#BUILD_DIR ?= /media/myssd/tmp/packer

# Preload VM with SSH keys (NOTE: relative to labvm/ dir!)
#ISC_AUTHORIZED_KEYS=../dist/authorized_keys

# Password for cloud VM's console
#ISC_CLOUD_VM_PASSWORD=iscrullz  # change this

