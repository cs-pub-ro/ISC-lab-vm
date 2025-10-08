## Makefile for ISC lab VMs
##

FRAMEWORK_DIR ?= ./framework
include $(FRAMEWORK_DIR)/framework.mk
include $(FRAMEWORK_DIR)/lib/inc_all.mk

# set default goals
DEFAULT_GOAL = labvm
INIT_GOAL = labvm
SUDO ?= sudo
# Debian uses 1 partition only
ZEROFREE_PART_NUM = 1

# Fresh Debian base VM
$(call vm_new_base_debian,base)
base-ver = 13

labvm-ver = $(ISC_LABVM_VERSION)
labvm-prefix = ISC_$(labvm-ver)

# VM with ISC lab customizations
$(call vm_new_layer_full_featured,labvm)
labvm-name = $(labvm-prefix)
labvm-src-from = base
labvm-script-prepare = isc-prepare.sh
labvm-copy-scripts += $(abspath ./labvm/scripts)/
labvm-extra-rules += $(vm_zerofree_rule)

# Export to VirtualBox & VMware
localvm-name = $(labvm-prefix)_Local
localvm-type = vm-combo
localvm-vmname = ISC $(labvm-ver) VM
localvm-src-from = labvm
localvm-extra-rules += $(vm_zerofree_rule)

# Cloud-init image
$(call vm_new_layer_cloud,cloud)
cloud-name = $(labvm-prefix)_cloud
cloud-src-from = labvm
cloud-copy-scripts += $(abspath ./cloud/scripts)/
cloud-extra-envs = "ISC_CLOUD_ADMIN_PASSWORD=$(ISC_CLOUD_ADMIN_PASSWORD)",
cloud-extra-rules += $(vm_zerofree_rule)

# list with all VMs to generate rules for (note: use dependency ordering!)
build-vms = base labvm localvm cloud

$(call vm_eval_all_rules)

