#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
## Attack target VM: machine identity + freeing the ports its services need

TARGET_HOSTNAME=isc-target

sh_log_info "Configuring attack target VM identity ($TARGET_HOSTNAME)..."

if [[ "$(hostname)" != "$TARGET_HOSTNAME" ]]; then
	hostnamectl set-hostname "$TARGET_HOSTNAME"
	sed -i "s/^127.0.1.1\s.*/127.0.1.1\t$TARGET_HOSTNAME/" /etc/hosts
fi

# labvm ships student-facing servers that would steal the target's ports
# (apache2: 80, openbsd-inetd: 23) or that it simply doesn't need (vsftpd,
# postfix, dhcp); the dns/snmp containers bind the host netns, so a local
# resolver or dhcp server must not run either
for svc in apache2 vsftpd postfix dnsmasq isc-dhcp-server \
	systemd-resolved openbsd-inetd inetd; do
	systemctl disable --now "$svc" 2>/dev/null || true
done
