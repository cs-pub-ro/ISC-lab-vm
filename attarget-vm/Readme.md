# ISC Lab 08 — attack target VM

A single VM that exposes a handful of deliberately vulnerable network services
(students recon it, exploit it, collect flags). It is *not* a student VM: it
shares the `labvm` image (Docker, tools, user setup) but nothing else.

Spec (ports, flags, services, hints): `.agents/TODO_Lab08_target_vm.md`.

## Build

```sh
make attargetvm          # local qcow2; `make attargetvm_edit` + `make ssh` to poke it
make attargetvm-cloud    # cloud-init variant, for the OpenStack deployment
```

Both derive from `labvm`, so build that first (`make labvm`).

## Layout

```
scripts/prepare-attargetvm.d/    provisioning snippets (stage 2 only)
scripts/files/opt/target/        payload, deployed to /opt/target on the VM
```

Everything the services need (compose stack, firewall, knockd, beacon, watchdog,
acceptance tests) lives under `/opt/target`; see its `Readme.md`.
