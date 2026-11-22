#!/bin/bash
# Lab 08 attack target — acceptance tests.
#
# Run on the target itself (default) or from any lab machine that can reach it:
#   tests/acceptance.sh [target-ip]
set -uo pipefail

T="${1:-127.0.0.1}"
fails=0

check() {  # check NAME COMMAND...
	local name="$1"; shift
	if "$@" >/dev/null 2>&1; then
		echo "PASS $name"
	else
		echo "FAIL $name"
		fails=$((fails + 1))
	fi
}

# --- F1: file/directory discovery
check "robots.txt points at /backup/" \
	sh -c "curl -fsS http://$T/robots.txt | grep -q 'Disallow: /backup/'"
check "F1 flag in /backup/" \
	sh -c "curl -fsS http://$T/backup/ | grep -q 'ISC{'"
check "dashboard itself has no flag" \
	sh -c "! curl -fsS http://$T/ | grep -q 'ISC{'"

# --- F2: service version discovery
check "F2 flag in the HTTP version banner (nmap -sV)" \
	sh -c "nmap -sV -p 80 $T | grep -q 'ISC{'"
check "F2 flag also visible in response headers" \
	sh -c "curl -fsSI http://$T/ | grep -q 'ISC{'"

# --- F3: SNMP
check "F3 flag in sysLocation" \
	sh -c "snmpwalk -v2c -c public -t 3 -r 1 $T 1.3.6.1.2.1.1.6.0 | grep -q 'ISC{'"

# --- F4: DNS zone transfer
check "F4 flag in the isc.lab zone transfer" \
	sh -c "dig +short @$T isc.lab AXFR | grep -q 'ISC{'"

# --- F5: port knocking
knock_seq() {
	if command -v knock >/dev/null 2>&1; then
		knock "$T" 11731 24472 39913
	else
		for port in 11731 24472 39913; do
			timeout 1 bash -c "echo >/dev/tcp/$T/$port" 2>/dev/null || true
		done
	fi
}
knock_then_fetch() {
	knock_seq
	sleep 1
	curl -fsS "http://$T:9999/" | grep -q 'ISC{'
}
check "9999 is filtered before the knock" \
	sh -c "nmap -Pn -p 9999 $T | grep -q 'filtered'"

# The knock only works from a remote source: a machine knocking its own address
# sends the packets over loopback, where knockd is not listening.
if [[ "$T" != "127.0.0.1" && "$T" != "localhost" ]] && \
		! ip -4 -br addr show 2>/dev/null | grep -qw "$T"; then
	check "F5 flag after the knock sequence" knock_then_fetch
else
	echo "SKIP F5 flag after the knock sequence (run from another machine)"
fi

echo
if (( fails )); then
	echo "$fails test(s) FAILED"
	exit 1
fi
echo "all tests passed"
