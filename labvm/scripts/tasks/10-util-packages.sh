#!/bin/bash
# VM install initialization
[[ "$INSIDE_INSTALL_SCRIPT" == "1" ]] || { echo "Direct calls not supported!">&2; exit 5; }

# terminal utilities
apt-get install --no-install-recommends -y tree tmux vim nano zip \
	bash-completion

# networking utils
apt-get install --no-install-recommends -y traceroute tcpdump dsniff rsync \
	whois elinks s-nail mailutils sharutils telnet dnsutils ftp nmap \
	bridge-utils iputils-ping iptables-persistent asciinema

# security utils
apt-get install --no-install-recommends -y iptables-persistent ltrace \
	exiftool binwalk sqlmap nikto john netcat-openbsd testdisk foremost \
	dosfstools mtools

# Build tools, python, libraries
apt-get install --no-install-recommends -y build-essential libc6-dev-i386 gdb gdbserver \
	python3 python3-venv python3-pip python3-setuptools libssl-dev libffi-dev \
	gcc-multilib libglib2.0-dev libc6-dbg sqlite3

# Add i386 libraries (required for pwndbg)
if uname -m | grep x86_64 >/dev/null; then
	dpkg --add-architecture i386
	apt-get update
	apt-get install -y libc6-dbg:i386 libgcc-s1:i386
fi

# Install a newer neovim (from unstable ppa)
add-apt-repository -y ppa:neovim-ppa/unstable
apt-get -y update && apt-get -y install neovim

# Install GoBuster
GOBUSTER_DEST=/tmp/gobuster.tar.gz
curl --fail --show-error --silent -L -o "$GOBUSTER_DEST" \
	"https://github.com/OJ/gobuster/releases/download/v3.6.0/gobuster_Linux_x86_64.tar.gz"
mkdir /tmp/gobuster/
tar xf "$GOBUSTER_DEST" -C "/tmp/gobuster"
cp -f "/tmp/gobuster/gobuster" /usr/local/bin/gobuster
chmod +x /usr/local/bin/gobuster

