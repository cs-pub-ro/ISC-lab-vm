#!/bin/bash
# VM install initialization

[[ "$INSIDE_INSTALL_SCRIPT" == "1" ]] || { echo "Direct calls not supported!">&2; exit 5; }

# prevent prompts from `apt`
export DEBIAN_FRONTEND=noninteractive

# uncomment to skip costly installation steps
SKIP_SGX_SDK=1
#SKIP_INSTALL_JAVACARD_SIM=1

# update the repos
apt-get update

