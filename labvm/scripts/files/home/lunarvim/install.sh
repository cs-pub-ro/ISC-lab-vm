#!/bin/bash
# Local LunarVim Installation script

python3 -m pip install --user pynvim

if [[ "$DEBUG" -gt 1 ]]; then
	rm -rf "$HOME/.local/share/lunarvim" "$HOME/.config/lvim" "$HOME/.cache/lvim"
fi

if [[ ! -d "$HOME/.local/share/lunarvim" ]]; then
	bash <(curl -s \
		https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) \
		--yes --no-install-dependencies
fi

