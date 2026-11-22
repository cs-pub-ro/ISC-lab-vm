#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
## Build & start the target's service stack (all containers use the host netns)

sh_log_info "Building target service images (needs network access)..."
cd /opt/target/compose
docker compose build

sh_log_info "Enabling the target-compose.service unit..."
install -m0644 /opt/target/host/target-compose.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable target-compose.service
systemctl restart target-compose.service

# fail the image build right here if a service didn't come up
function _wait_for() {
	local what="$1"; shift
	for _ in $(seq 1 30); do
		"$@" && return 0
		sleep 1
	done
	sh_log_error "timed out waiting for $what"
	return 1
}
_wait_for "web (80/tcp)" curl -fsS -o /dev/null http://127.0.0.1/
_wait_for "snmp (161/udp)" snmpwalk -v2c -c public -t 2 -r 1 \
	127.0.0.1 1.3.6.1.2.1.1.6.0
