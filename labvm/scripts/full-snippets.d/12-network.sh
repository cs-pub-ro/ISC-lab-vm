#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# VM network configuration

# Change hostname to isc-vm
if [[ "$(hostname)" != "isc-vm" ]]; then
	hostnamectl set-hostname isc-vm
	sed -i "s/^127.0.1.1\s.*/127.0.1.1       isc-vm/g"  /etc/hosts
fi

