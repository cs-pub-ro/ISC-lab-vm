#!/bin/bash
# A simple guest account-based attack-defense scenario for the networking lab

# add "hacker" (our guest) account
id -g hacker 1>/dev/null 2>/dev/null || groupadd -g 1337 hacker
id -u hacker 1>/dev/null 2>/dev/null || useradd -m -u 1337 -g 1337 -s /usr/bin/bash hacker
usermod -L -e 1 hacker
echo "hacker:student" | chpasswd

if [[ -n "$DEBUG" && "$DEBUG" -gt 0 ]]; then
	# unlock the user!
	usermod -e -1 -U hacker
fi

# make ssh-ing to guest possible only from inside the OpenStack network
cat <<EOF >"/etc/ssh/sshd_config.d/30-hacker.conf"
Match Host "!10.9.*.*,*"
	DenyUsers hacker
Match Host "10.9.*.*"
	AllowUsers hacker
Match User "hacker"
	PasswordAuthentication yes
EOF

