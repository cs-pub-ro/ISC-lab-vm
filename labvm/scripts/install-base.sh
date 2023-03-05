#!/bin/bash
# Base install (requiring reboot)
# Everything should run as root

set -eo pipefail
export SRC="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
chmod +x "$SRC/"*.sh
source "$SRC/_common.sh"

wait_for_vm_boot

if [[ "$VM_NOINSTALL" == "1" ]]; then
	exit 0
fi

# generate locales
locale-gen "en_US.UTF-8"
localectl set-locale LANG=en_US.UTF-8

export DEBIAN_FRONTEND=noninteractive
# remove some useless packages like snapd and stock docker
apt-get purge snapd docker.io || true
apt-get update
apt-get -y upgrade
# remove older kernels
apt-get -y --purge autoremove
# virtualization drivers & base networking
apt-get install --no-install-recommends -y open-vm-tools iproute2

# Disable UFW (if present)
systemctl disable ufw || true
# Change hostname to isc-vm
hostnamectl set-hostname isc-vm
sed -i "s/^127.0.1.1\s.*/127.0.1.1       isc-vm/g"  /etc/hosts

if grep -q " biosdevname=0 " /proc/cmdline; then
	exit 0
fi

echo "blacklist floppy" > /etc/modprobe.d/blacklist-floppy.conf
dpkg-reconfigure initramfs-tools

# Use old interface names (ethX) + disable qxl modeset (spice is buggy)
GRUB_CMDLINE_LINUX="quiet net.ifnames=0 biosdevname=0 nomodeset"

sed -i "s/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"$GRUB_CMDLINE_LINUX\"/g" /etc/default/grub
update-grub

# update netplan config to use eth0
echo "
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: true
" > /etc/netplan/01-netcfg.yaml

# reboot
systemctl stop sshd.service
nohup shutdown -r now < /dev/null > /dev/null 2>&1 &
sleep 1
exit 0

