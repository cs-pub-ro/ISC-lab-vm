#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
## Base firewall (run last: everything that needs the network is done before)

sh_log_info "Installing the target firewall..."

chmod 0755 /opt/target/host/firewall.sh
install -m0644 /opt/target/host/target-firewall.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable target-firewall.service
systemctl restart target-firewall.service

iptables -S INPUT | grep -q -- '-P INPUT DROP' || {
	sh_log_error "INPUT policy is not DROP"; return 1; }
iptables -S OUTPUT | grep -q -- '-P OUTPUT DROP' || {
	sh_log_error "OUTPUT policy is not DROP"; return 1; }
