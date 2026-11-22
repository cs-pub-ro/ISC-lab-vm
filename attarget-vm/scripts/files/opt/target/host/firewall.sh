#!/bin/bash
# Base firewall for the attack target.
#
# Idempotent and append-only: it is re-asserted at boot (target-firewall.service)
# and later by the watchdog, while knockd keeps temporary per-IP ACCEPT rules
# in the same chain. Never flush here — a flush would drop knockd's rules.
set -eu

# the students' VLAN; everything else is not reachable either way
LAB_SUBNET="${LAB_SUBNET:-10.9.0.0/24}"

_rule() {  # _rule CHAIN SPEC...
	local chain="$1"; shift
	iptables -C "$chain" "$@" 2>/dev/null || iptables -A "$chain" "$@"
}

# fail closed
iptables -P INPUT DROP
iptables -P FORWARD DROP

# always allow: loopback, replies to our own connections, pings
_rule INPUT -i lo -j ACCEPT
_rule INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
_rule INPUT -p icmp --icmp-type echo-request -j ACCEPT

# public services — add a port here when its service lands
for port in 22 53 80; do
	_rule INPUT -p tcp --dport "$port" -j ACCEPT
done
_rule INPUT -p udp --dport 53 -j ACCEPT
_rule INPUT -p udp --dport 161 -j ACCEPT
_rule INPUT -p udp --dport 68 -j ACCEPT            # DHCP replies

# knock-gated console: stays closed until the knock sequence is seen
_rule INPUT -p tcp --dport 9999 -j DROP

# egress: the lab VLAN, the cloud metadata service and DHCP only — the target
# must not become a pivot towards campus or the internet
iptables -P OUTPUT DROP
_rule OUTPUT -o lo -j ACCEPT
_rule OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
_rule OUTPUT -d "$LAB_SUBNET" -j ACCEPT
_rule OUTPUT -d 169.254.0.0/16 -j ACCEPT           # cloud metadata
_rule OUTPUT -p udp --dport 67 -j ACCEPT           # DHCP requests
_rule OUTPUT -p icmp -j ACCEPT
