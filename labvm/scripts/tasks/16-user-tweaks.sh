#!/bin/bash
# VM install initialization
[[ "$INSIDE_INSTALL_SCRIPT" == "1" ]] || { echo "Direct calls not supported!">&2; exit 5; }


# copy user home configs
_install_home_config() {
	local USER="$1"
	local DEST="$2"
	# bashrc:
	su -c "mkdir -p $DEST/.config" - "$USER"
	install -m755 -o"$USER" -g"$USER" "$SRC/files/home/bashrc" "$DEST/.bashrc"

	# tmux config (for user, only):
	if [[ "$USER" != "root" ]]; then
		su -c "mkdir -p $DEST/.config/tmux" - "$USER"
		rsync -ai --chown="$USER:$USER" "$SRC/files/home/tmux/" "$DEST/.config/tmux/"
		ln -sf "$DEST/.config/tmux/tmux.conf" "$DEST/.tmux.conf"
		chown "$USER:$USER" "$DEST/.tmux.conf"
	fi

	# zsh config:
	su -c "mkdir -p $DEST/.config/zsh/" - "$USER"
	rsync -ai --chown="$USER:$USER" "$SRC/files/home/zsh/" "$DEST/.config/zsh/"
	su -c "ln -sf '$DEST/.config/zsh/zshrc' '$DEST/.zshrc'" - "$USER"
	chsh -s /usr/bin/zsh "$USER"
	# run zsh for user to install plugins
	su -c 'zsh -i -c "source ~/.zshrc; exit 0"' - "$USER"

	# install lunarvim
	su -c "mkdir -p $DEST/.config/lvim" - "$USER"
	rsync -ai --chown="$USER:$USER" "$SRC/files/home/lunarvim/" "$DEST/.config/lunarvim.install/"
	su -c "bash $DEST/.config/lunarvim.install/install.sh" - "$USER"
	su -c "cp -f '$DEST/.config/lunarvim.install/config.lua' '$DEST/.config/lvim/config.lua'" - "$USER"
}
_install_home_config root /root
_install_home_config student /home/student

