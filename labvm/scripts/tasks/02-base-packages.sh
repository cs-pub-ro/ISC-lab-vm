#!/bin/bash
# VM install initialization
[[ "$INSIDE_INSTALL_SCRIPT" == "1" ]] || { echo "Direct calls not supported!">&2; exit 5; }


apt-get install --no-install-recommends -y \
	apt-transport-https ca-certificates curl wget software-properties-common \
	git unrar unzip zsh vim neovim # parallel

if [[ -n "$FULL_UPGRADE" ]]; then
	apt-get dist-upgrade -y
fi

