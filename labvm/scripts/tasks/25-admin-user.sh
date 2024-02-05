#!/bin/bash
# Admin user provisioning
# Will be used for provisioning the practical VM because student will be made less privileged!
#
[[ "$INSIDE_INSTALL_SCRIPT" == "1" ]] || { echo "Direct calls not supported!">&2; exit 5; }

# create the admin user
id -g admin 1>/dev/null 2>/dev/null || groupadd -g 1966 admin
id -u admin 1>/dev/null 2>/dev/null || useradd -m -u 1966 -g 1966 -s /usr/bin/bash admin
usermod -aG "docker,sudo" admin
echo 'admin ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/admin
# Note: this will be changed in private VMs, won't bring you any flag :P
echo "admin:admin1337" | chpasswd

