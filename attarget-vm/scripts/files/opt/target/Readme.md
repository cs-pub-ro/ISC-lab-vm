# ISC Lab 08 attack target

One-shot VM exposing deliberately vulnerable network services for the
network-security lab. Built as an image, then deployed once (shared target).

Provisioned by the `attarget-vm` layer of the ISC lab VM repository.

    compose/       docker compose stack (all services, host networking)
    host/          target-compose.service (+ knockd, firewall, watchdog later)
    pristine/      pristine copy used by the watchdog to undo vandalism
    tests/         acceptance tests

## Current services

    80/tcp    web    "ISC Sensor Gateway" dashboard; /backup/ holds f1,
                     the Server banner is the version f2 (`nmap -sV`)
    161/udp   snmp   public read-only community; sysLocation holds f3

Flags are plain literals in the file that serves them (the page, `app.py`, or
`snmpd.conf`) — no templating, no rotation.

## Testing

    tests/acceptance.sh [target-ip]      # defaults to 127.0.0.1 (run on the VM)
