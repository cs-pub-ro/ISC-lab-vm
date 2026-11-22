#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
## Attack target VM: post-install cleanup

# the payload is already deployed to /opt/target; don't keep a second copy
rm -rf /opt/vm-scripts/files

pkg_cleanup || true
