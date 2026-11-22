#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
## Port knocking (F5): knockd + its gate rule (the console itself is a container)

sh_log_info "Configuring knockd and the 9999 gate..."

install -m0600 /opt/target/host/knockd.conf /etc/knockd.conf
chmod 0755 /opt/target/host/knock-gate.sh
install -D -m0644 /opt/target/host/systemd/knockd.service.d/10-gate.conf \
	/etc/systemd/system/knockd.service.d/10-gate.conf

# the drop-in runs knock-gate.sh first, so 9999 is already DROPped when knockd
# starts listening for the sequence
systemctl daemon-reload
systemctl enable knockd
systemctl restart knockd

systemctl is-active --quiet knockd || {
	sh_log_error "knockd did not start"
	journalctl -u knockd --no-pager -n 20
	return 1
}
iptables -C INPUT -p tcp --dport 9999 -j DROP 2>/dev/null || {
	sh_log_error "the 9999 gate rule was not applied"
	return 1
}

# 9999 must not answer without a knock. The knock itself can only be tested
# from another machine: packets a VM sends to its own address go over loopback,
# and knockd listens on the real interface.
if curl -fsS --max-time 3 -o /dev/null "http://127.0.0.1:9999/"; then
	sh_log_error "9999 answers without a knock"
	return 1
fi
