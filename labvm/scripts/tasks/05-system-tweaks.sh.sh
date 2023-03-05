#!/bin/bash
# VM system tweaks
[[ "$INSIDE_INSTALL_SCRIPT" == "1" ]] || { echo "Direct calls not supported!">&2; exit 5; }

# remove MOTD, disable SSH dns lookup
sed -i 's/^ENABLED.*/ENABLED=0/' /etc/default/motd-news
sed -i 's/^UseDNS.*/UseDNS no/' /etc/ssh/sshd_config

# tell GAI that we prefer ipv4, thanks
GAI_PREFER_IPV4="precedence ::ffff:0:0/96  100"
gai_file="/etc/gai.conf"
if ! grep "^$GAI_PREFER_IPV4" "$gai_file"; then
	echo "$GAI_PREFER_IPV4" >> "$gai_file"
fi

