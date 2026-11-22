# ISC Lab 08 attack target

One-shot VM exposing deliberately vulnerable network services for the
network-security lab. Built as an image, then deployed once (shared target).

Provisioned by the `attarget-vm` layer of the ISC lab VM repository.

    compose/       docker compose stack (all services, host networking)
    host/          knockd.conf, firewall.sh, beacon.py, watchdog.sh, reset.sh
    flags/flags.d  flag templates ({{TOKEN}} rendered by provisioning)
    pristine/      pristine copy used by the watchdog to undo vandalism
    tests/         acceptance tests
