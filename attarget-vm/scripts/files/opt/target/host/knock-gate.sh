#!/bin/bash
# Keep 9999/tcp closed until a client performs the knock sequence (F5).
#
# Idempotent and *append*-only: knockd inserts its temporary per-IP ACCEPT rule
# at position 1, so it always matches before this DROP. Never flush here.
set -eu

iptables -C INPUT -p tcp --dport 9999 -j DROP 2>/dev/null ||
	iptables -A INPUT -p tcp --dport 9999 -j DROP
