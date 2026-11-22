#!/usr/bin/env python3
"""UDP status beacon — the "sensors broadcast their status on the LAN" story.

Sends one unencrypted datagram every 10 s to the subnet broadcast address on
UDP 9998. Anyone on the VLAN with `tcpdump -ni eth0 -A udp port 9998` reads the
flag without touching the target: passive sniffing, task F8.
"""

import ipaddress
import os
import socket
import subprocess
import time

PORT = int(os.environ.get("BEACON_PORT", "9998"))
INTERVAL = float(os.environ.get("BEACON_INTERVAL", "10"))

PAYLOAD = (
	"ISC-SENSOR v1 device=target temp=21.4 hum=44 "
	"secret=ISC{f8_br0adc4st_l34k}"
)


def broadcast_addr():
	"""Subnet broadcast of the first global IPv4 address (BEACON_BCAST wins)."""
	if os.environ.get("BEACON_BCAST"):
		return os.environ["BEACON_BCAST"]
	try:
		out = subprocess.run(
			["ip", "-4", "-o", "addr", "show", "scope", "global"],
			capture_output=True, text=True, check=True,
		).stdout
		address = out.split()[3]  # e.g. 10.9.9.9/24
		return str(ipaddress.ip_interface(address).network.broadcast_address)
	except (OSError, IndexError, ValueError, subprocess.CalledProcessError):
		return "10.9.0.255"


def main():
	sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
	dest = (broadcast_addr(), PORT)
	print("beacon: sending to %s:%d every %ss" % (dest[0], dest[1], INTERVAL),
		flush=True)
	while True:
		try:
			sock.sendto(PAYLOAD.encode(), dest)
		except OSError as exc:
			print("beacon: send failed: %s" % exc, flush=True)
		time.sleep(INTERVAL)


if __name__ == "__main__":
	main()
