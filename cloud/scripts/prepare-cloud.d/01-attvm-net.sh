#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
## The attack-target image enables its firewall at boot; that would block the
## cloud layer's apt / cloud-init network access, so lift it for the build.
## (It is re-armed in 91-attvm-firewall.sh.) No-op for the plain lab VM.

[[ -f /etc/systemd/system/target-firewall.service ]] || return 0

sh_log_info "Lifting the attack target firewall for the cloud build..."
systemctl disable --now target-firewall.service 2>/dev/null || true
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
