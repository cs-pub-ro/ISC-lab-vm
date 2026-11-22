# ISC Lab 08 attack target

One-shot VM exposing deliberately vulnerable network services for the
network-security lab. Built as an image, then deployed once (shared target).

Provisioned by the `attarget-vm` layer of the ISC lab VM repository.

    compose/       docker compose stack (all services, host networking)
    host/          target-compose.service (+ knockd, firewall, watchdog later)
    pristine/      pristine copy used by the watchdog to undo vandalism
    tests/         acceptance tests

## Current services

    23/tcp    telnet  old console, operator:operator; home flag f6
    53/tcp+udp dns    zone isc.lab, open AXFR; the flag TXT holds f4
    79/tcp    finger  user list + operator's .plan; the plan holds f7
    80/tcp    web     "ISC Sensor Gateway" dashboard; /backup/ holds f1,
                      the Server banner is the version f2 (`nmap -sV`)
    161/udp   snmp    public read-only community; sysLocation holds f3
    8080/tcp  apache  Apache 2.4.49, CVE-2021-41773 traversal; /flag holds f9
    9999/tcp  knock   maintenance console, only after the knock (f5)

Flags are plain literals in the file that serves them (the page, `app.py`, or
`snmpd.conf`) — no templating, no rotation.

The host firewall (host/firewall.sh, target-firewall.service) drops
everything but the published ports and limits egress to the lab VLAN,
the metadata service and DHCP.

## Testing

    tests/acceptance.sh [target-ip]      # defaults to 127.0.0.1 (run on the VM)
