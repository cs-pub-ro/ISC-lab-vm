#!/bin/bash
# VM install initialization
[[ "$INSIDE_INSTALL_SCRIPT" == "1" ]] || { echo "Direct calls not supported!">&2; exit 5; }


# copy user home configs
_install_home_config() {
	local USER="$1"
	local DEST="$2"
	# bashrc:
	install -m755 -o"$USER" -g"$USER" "$SRC/files/home/bashrc" "$DEST/.bashrc"

	# tmux config (for user, only):
	if [[ "$USER" == "student" ]]; then
		rsync -ai --mkpath --chown="$USER:$USER" "$SRC/files/home/tmux/" "$DEST/.config/tmux/"
		ln -sf "$DEST/.config/tmux/tmux.conf" "$DEST/.tmux.conf"
		chown "$USER:$USER" "$DEST/.tmux.conf"
	fi

	# zsh config:
	rsync -ai --mkpath --chown="$USER:$USER" "$SRC/files/home/zsh/" "$DEST/.config/zsh/"
	ln -sf "$DEST/.config/zsh/zshrc" "$DEST/.zshrc"
	chown "$USER:$USER" "$DEST/.zshrc"
	chsh -s /usr/bin/zsh "$USER"
	# run zsh for user to install plugins
	su -c 'zsh -c "source ~/.zshrc; exit 0"' - "$USER"
}
_install_home_config root /root
_install_home_config student /home/student

