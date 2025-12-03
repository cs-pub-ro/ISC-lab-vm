#!/bin/bash
# A simple guest account-based attack-defense scenario for the networking lab

# add "hacker" (our guest) account
sh_create_user hacker 1337
usermod -e -1 hacker
usermod -aG tty hacker
echo "hacker:student31337" | chpasswd

# install labvm-dotfiles for 'hacker' user, too
function _install_hacker_config() {
	set -e
	# hackers use vanilla vim!
	"$ISC_SRC/files/labvm-dotfiles/install.sh" -nvim
}
_exported_script="$(declare -p ISC_SRC); $(declare -f _install_hacker_config)"
chsh -s /usr/bin/zsh "hacker"
echo "$_exported_script; _install_hacker_config" | su -c bash "hacker"

# make ssh-ing to guest possible only from inside the OpenStack network
cat <<EOF >"/etc/ssh/sshd_config.d/30-hacker.conf"
Match Host "!10.9.*.*,*"
	DenyUsers hacker
Match Host "10.9.*.*"
	AllowUsers hacker
Match User "hacker"
	PasswordAuthentication yes
EOF

# finally, lock & expire password for hacker to make in un-loggable for now
usermod -L -e 1 hacker
if [[ -n "$DEBUG" && "$DEBUG" -gt 0 ]]; then
	# unlock the user!
	usermod -e -1 -U hacker
fi

