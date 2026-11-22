#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
## Host-side tooling for the attack target (the vulnerable services are containers)

sh_log_info "Installing target host packages..."

# iptables: base rules + knockd's temporary ACCEPT
# knockd:   port-knocking gate for 9999 (also ships the `knock` client)
# tcpdump:  post-exploitation sniffing from a foothold
# socat:    31337 decoy banner
# curl, dnsutils, snmp: acceptance tests run from localhost too
pkg_install --no-install-recommends -y iptables knockd tcpdump socat \
	curl dnsutils snmp
