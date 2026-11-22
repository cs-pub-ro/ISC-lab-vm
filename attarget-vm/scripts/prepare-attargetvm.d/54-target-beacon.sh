#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
## Passive sniffing target (F8): the status beacon broadcast on udp/9998

sh_log_info "Starting the status beacon..."

install -m0644 /opt/target/host/target-beacon.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable target-beacon.service
systemctl restart target-beacon.service

systemctl is-active --quiet target-beacon.service || {
	sh_log_error "the beacon did not start"
	journalctl -u target-beacon.service --no-pager -n 20
	return 1
}

# one beacon interval is 10s, so 25s always covers a datagram
if ! timeout 25 tcpdump -ni any -c 1 -A 'udp port 9998' 2>/dev/null | grep -q 'ISC{'; then
	sh_log_error "no beacon datagram was seen"
	return 1
fi
