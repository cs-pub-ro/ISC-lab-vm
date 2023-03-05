#!/bin/bash

python3 -m pip install --user pynvim

# Local LunarVim Installation script
rm -rf "$HOME/.local/share/lunarvim" "$HOME/.config/lvim" "$HOME/.cache/lvim"

bash <(curl -s \
	https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) \
	--yes --no-install-dependencies

