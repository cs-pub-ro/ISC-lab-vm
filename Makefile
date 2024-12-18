## Makefile for ISC lab VMs
##

FRAMEWORK_DIR ?= ./framework
include $(FRAMEWORK_DIR)/framework.mk

# set default goals
DEFAULT_GOAL = labvm
INIT_GOAL = labvm
SUDO = sudo

# Fresh Ubuntu Server base VM
ubuntu-ver = 22
basevm-name = ubuntu_$(ubuntu-ver)_base
basevm-packer-src = $(FRAMEWORK_DIR)/basevm
basevm-src-image = $(BASE_VM_INSTALL_ISO)

# VM with lab-specific customizations
labvm-ver = $(ISC_LABVM_VERSION)
labvm-name = ISC_$(labvm-ver)
labvm-packer-src = ./labvm
labvm-packer-args = -var "isc_authorized_keys=$(ISC_AUTHORIZED_KEYS)"
labvm-src-from = basevm
define labvm-extra-rules=
.PHONY: labvm_compact labvm_zerofree
labvm_zerofree: labvm_compact
labvm_compact:
	$(SUDO) "$(FRAMEWORK_DIR)/utils/zerofree.sh" "$$(labvm-dest-image)"
endef

# Cloud-init image (based on examplevm!, see src-image)
cloudvm-name = ISC_$(labvm-ver)_cloud
cloudvm-packer-src = $(FRAMEWORK_DIR)/cloudvm
cloudvm-packer-args = -var "vm_password=$(ISC_CLOUD_VM_PASSWORD)"
cloudvm-src-from = labvm
define cloudvm-extra-rules=
.PHONY: cloudvm_compact cloudvm_zerofree
cloudvm_zerofree: cloudvm_compact
cloudvm_compact:
	$(SUDO) "$(FRAMEWORK_DIR)/utils/zerofree.sh" "$$(cloudvm-dest-image)"
	qemu-img convert -O qcow2 "$$(cloudvm-dest-image)" "$$(cloudvm-dest-image).compact.qcow2"
	ls -lh "$$(cloudvm-dest-image)"
endef

# list with all VMs to generate rules for (note: use dependency ordering!)
build-vms += basevm labvm cloudvm

$(call eval_common_rules)
$(call eval_all_vm_rules)

