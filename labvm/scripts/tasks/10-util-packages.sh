#!/bin/bash
# VM install initialization
[[ "$INSIDE_INSTALL_SCRIPT" == "1" ]] || { echo "Direct calls not supported!">&2; exit 5; }

# terminal / networking / utilities
apt-get install --no-install-recommends -y tree tmux vim nano neovim \
	bash-completion traceroute tcpdump dsniff rsync whois elinks \
	s-nail mailutils sharutils telnet dnsutils ftp nmap  \
	iptables-persistent asciinema

# Build tools, python, libraries
apt-get install --no-install-recommends -y build-essential libc6-dev-i386 gdb python3 \
	python3-pip libssl-dev libffi-dev

# H4x0r tools
apt-get install -y ophcrack john netcat-openbsd  \
	testdisk foremost dmidecode dosfstools mtools

