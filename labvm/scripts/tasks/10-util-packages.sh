#!/bin/bash
# VM install initialization
[[ "$INSIDE_INSTALL_SCRIPT" == "1" ]] || { echo "Direct calls not supported!">&2; exit 5; }

# terminal / networking / utilities
apt-get install --no-install-recommends -y tree tmux vim nano \
	bash-completion traceroute tcpdump dsniff rsync whois elinks \
	s-nail mailutils sharutils telnet dnsutils ftp nmap iputils-ping  \
	iptables-persistent asciinema exiftool nikto

# Build tools, python, libraries
apt-get install --no-install-recommends -y build-essential libc6-dev-i386 gdb gdbserver \
	python3 python3-venv python3-pip python3-setuptools libssl-dev libffi-dev \
	gcc-multilib libglib2.0-dev libc6-dbg

# Add i386 libraries (for pwndbg)
if uname -m | grep x86_64 >/dev/null; then
	dpkg --add-architecture i386
	apt-get update
	apt-get install -y libc6-dbg:i386 libgcc-s1:i386
fi

# H4x0r tools
apt-get install --no-install-recommends -y john netcat-openbsd  \
	testdisk foremost dosfstools mtools

# Install a newer neovim (from unstable ppa)
add-apt-repository -y ppa:neovim-ppa/unstable
apt-get -y update
apt-get -y install neovim

