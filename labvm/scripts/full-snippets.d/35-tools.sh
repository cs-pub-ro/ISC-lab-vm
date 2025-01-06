#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Install linux / security / pentest tools

# terminal utilities: (mostly also covered in fully_featured)
pkg_install --no-install-recommends tmux vim-nox nano bash-completion less \
	pciutils usbutils lshw sysstat

# security utils
pkg_install --no-install-recommends ltrace exiftool binwalk sqlmap nikto john \
	netcat-openbsd testdisk foremost

# python / dev libraries
pkg_install --no-install-recommends \
	python3 python3-venv python3-pip python3-setuptools libssl-dev libffi-dev

# Add i386 libraries (required for pwndbg)
if uname -m | grep x86_64 >/dev/null; then
	dpkg --add-architecture i386
	apt-get update
	apt-get install -y libc6-dbg:i386 libgcc-s1:i386
fi

# Install a newer neovim (from unstable ppa)
add-apt-repository -y ppa:neovim-ppa/unstable
pkg_init_update
pkg_install neovim

# Install GoBuster
GOBUSTER_DEST=/tmp/gobuster.tar.gz
curl --fail --show-error --silent -L -o "$GOBUSTER_DEST" \
	"https://github.com/OJ/gobuster/releases/download/v3.6.0/gobuster_Linux_x86_64.tar.gz"
mkdir /tmp/gobuster/
tar xf "$GOBUSTER_DEST" -C "/tmp/gobuster"
cp -f "/tmp/gobuster/gobuster" /usr/local/bin/gobuster
chmod +x /usr/local/bin/gobuster

