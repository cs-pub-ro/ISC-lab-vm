#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Install linux / security / pentest tools

# install fetch.sh script
FETCH_SCRIPT_URL="https://raw.githubusercontent.com/niflostancu/release-fetch-script/master/fetch.sh"
sudo wget -O /usr/local/bin/fetch.sh "$FETCH_SCRIPT_URL"
chmod +x /usr/local/bin/fetch.sh

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

# Install a newer neovim (from github releases)
NEOVIM_DEST="/opt/nvim"
NEOVIM_URL="https://github.com/neovim/neovim/releases/download/{VERSION}/nvim-linux-x86_64.tar.gz"
NEOVIM_ARCHIVE=/tmp/nvim-linux.tar.gz
fetch.sh --download=/tmp/nvim-linux.tar.gz "$NEOVIM_URL"
rm -rf "$NEOVIM_DEST" && mkdir -p "$NEOVIM_DEST"
tar xf /tmp/nvim-linux.tar.gz --strip-components=1 -C "$NEOVIM_DEST"
ln -sf "$NEOVIM_DEST/bin/nvim" "/usr/local/bin/nvim"

# Install GoBuster
GOBUSTER_URL="https://github.com/OJ/gobuster/releases/download/{VERSION}/gobuster_Linux_x86_64.tar.gz"
GOBUSTER_ARCHIVE=/tmp/gobuster.tar.gz
fetch.sh --download="$GOBUSTER_ARCHIVE" "$GOBUSTER_URL"
mkdir /tmp/gobuster/
tar xf "$GOBUSTER_ARCHIVE" -C "/tmp/gobuster"
cp -f "/tmp/gobuster/gobuster" /usr/local/bin/gobuster
chmod +x /usr/local/bin/gobuster

