#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# ISC VM configuration vars

ISC_SRC=$(sh_get_script_path)/..

# Enable all features from the full_featured layer
VM_LEGACY_IFNAMES=1
VM_SYSTEM_TWEAKS=1
VM_INSTALL_TERM_TOOLS=1
VM_INSTALL_NET_TOOLS=1
VM_INSTALL_DEV_TOOLS=1
VM_INSTALL_HACKING_TOOLS=1
VM_INSTALL_DOCKER=1
VM_USER_TWEAKS=1
VM_USER_BASH_CONFIGS=1
VM_USER_ZSH_CONFIGS=1

# uncomment to skip costly installation steps
SKIP_SGX_SDK=1
SKIP_INSTALL_JAVACARD_SIM=1

