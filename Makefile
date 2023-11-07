## Makefile for ISC lab VMs
##

FRAMEWORK_DIR ?= ./framework
include $(FRAMEWORK_DIR)/framework.mk

# set default goals
DEFAULT_GOAL = labvm
INIT_GOAL = labvm

# Fresh Ubuntu Server base VM
ubuntu-ver = 22
basevm-name = ubuntu_$(ubuntu-ver)_base
basevm-packer-src = $(FRAMEWORK_DIR)/basevm
basevm-src-image = $(BASE_VM_INSTALL_ISO)

# VM with lab-specific customizations
labvm-ver = 2023
labvm-name = ISC_$(labvm-ver)
labvm-packer-src = ./labvm
labvm-src-image = $(basevm-dest-image)

# Cloud-init image (based on examplevm!, see src-image)
cloudvm-name = ISC_$(labvm-ver)_cloud
cloudvm-packer-src = $(FRAMEWORK_DIR)/cloudvm
cloudvm-src-image = $(labvm-dest-image)

# list with all VMs to generate rules for (note: use dependency ordering!)
build-vms += basevm labvm cloudvm

$(call eval_common_rules)
$(call eval_all_vm_rules)

