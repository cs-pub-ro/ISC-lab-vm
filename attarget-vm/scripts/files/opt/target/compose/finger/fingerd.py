#!/usr/bin/env python3
"""Naive RFC 1288 finger server — deliberately leaky (task F7).

finger is an enumeration gift: it answers an unauthenticated query with the
list of users, and for a single user it dumps their `.plan` file. Nothing here
is a bug in the usual sense — the protocol itself has no access control, which
is exactly the lesson.
"""

import socket
import threading
from pathlib import Path

PLANS_DIR = Path("/plans")
PORT = 79

USERS = {
	"operator": "Operator",
	"guest": "Guest",
	"sensor": "Sensor firmware",
}


def plan_for(user):
	try:
		return (PLANS_DIR / user).read_text().strip()
	except OSError:
		return ""


def render(users):
	if not users:
		lines = ["Login     Name", "--------  ----------------"]
		for user, name in USERS.items():
			lines.append("%-9s %s" % (user, name))
		return "\n".join(lines) + "\n"

	out = []
	for user in users:
		if user not in USERS:
			out.append("%s: no such user.\n" % user)
			continue
		out.append("Login: %s\t\tName: %s\n" % (user, USERS[user]))
		out.append("Plan:\n%s\n" % plan_for(user))
	return "".join(out)


def handle(conn):
	with conn:
		conn.settimeout(5)
		query = b""
		while not query.endswith(b"\n"):
			chunk = conn.recv(1024)
			if not chunk:
				break
			query += chunk
		# the classic client sends `/W user@host`; `/W` is just a format switch
		users = [
			token.split("@")[0]
			for token in query.decode(errors="replace").split()
			if not token.startswith("/")
		]
		conn.sendall(render(users).encode())


def main():
	server = socket.socket()
	server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	server.bind(("0.0.0.0", PORT))
	server.listen(16)
	while True:
		conn, _ = server.accept()
		threading.Thread(target=handle, args=(conn,), daemon=True).start()


if __name__ == "__main__":
	main()
