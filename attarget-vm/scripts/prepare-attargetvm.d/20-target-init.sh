#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
## Attack target VM: machine identity + freeing the ports its services need

TARGET_HOSTNAME=isc-target

sh_log_info "Configuring attack target VM identity ($TARGET_HOSTNAME)..."

if [[ "$(hostname)" != "$TARGET_HOSTNAME" ]]; then
	hostnamectl set-hostname "$TARGET_HOSTNAME"
	sed -i "s/^127.0.1.1\s.*/127.0.1.1\t$TARGET_HOSTNAME/" /etc/hosts
fi

# the dns/snmp containers bind the host network namespace; a local resolver
# would fight them for port 53
for svc in systemd-resolved dnsmasq; do
	systemctl disable --now "$svc" 2>/dev/null || true
done
