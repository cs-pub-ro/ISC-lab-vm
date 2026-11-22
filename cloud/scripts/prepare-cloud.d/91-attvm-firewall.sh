#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
## Re-arm the attack target firewall in the cloud image (see 01-attvm-net.sh).
## The rules are applied by the unit at boot; here we only make sure it is
## enabled for the deployed VM. No-op for the plain lab VM.

[[ -f /etc/systemd/system/target-firewall.service ]] || return 0

sh_log_info "Re-enabling the attack target firewall for boot..."
systemctl enable target-firewall.service
systemctl is-enabled --quiet target-firewall.service || {
	sh_log_error "target-firewall.service is not enabled"
	return 1
}
