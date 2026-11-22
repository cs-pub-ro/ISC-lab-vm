#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
## Deploy the attack target payload onto the VM (/opt/target)

sh_log_info "Deploying target payload to /opt/target..."

# runtime tree (services, host helpers, watchdog's pristine copy)
install -d -m0755 /opt/target/{compose,host,pristine,tests}
rsync -avh --chown=root:root "$ATTVM_SRC/files/opt/target/" /opt/target/
