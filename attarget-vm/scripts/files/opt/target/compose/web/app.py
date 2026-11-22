#!/usr/bin/env python3
"""ISC Sensor Gateway — the lab's deliberately leaky "device manager" web UI.

Flags:
  * f1 in the static page under /backup/  (directory discovery),
  * f2 in the HTTP version banner         (`nmap -sV` prints it as the service
    version, exactly like the real "nginx 1.18.0 (Ubuntu)" output).
"""

import http.server
import os

WWW_DIR = os.environ.get("WWW_DIR", "/www")
PORT = int(os.environ.get("PORT", "80"))

# kept short on purpose: nmap reports "ISC-DeviceManager/3.1.4 (ISC{f2_0utd4t3d_f1rmw4r3})"
SERVER_VERSION = "ISC-DeviceManager/3.1.4 (ISC{f2_0utd4t3d_f1rmw4r3})"


class Handler(http.server.SimpleHTTPRequestHandler):
    # drop stalled connections quickly: nmap's service probes that never send a
    # complete request line would otherwise hold the socket for its full timeout
    timeout = 3

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=WWW_DIR, **kwargs)

    def version_string(self):
        return SERVER_VERSION


if __name__ == "__main__":
    http.server.ThreadingHTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
