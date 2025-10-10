#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# VM install initialization

# this will be ran as the `student` / `root` users
function _install_home_config() {
	set -e
	# install labvm-dotfiles:
	"$ISC_SRC/files/labvm-dotfiles/install.sh"

	# pwndbg!
	[[ -d "$HOME/.pwndbg" ]] || git clone https://github.com/pwndbg/pwndbg "$HOME/.pwndbg"
	(
		cd "$HOME/.pwndbg";
		PWNDBG_VENV_PATH=./.venv
		# create Python virtual environment and install dependencies in it
		[[ -d "${PWNDBG_VENV_PATH}" ]] || python3 -m venv -- ${PWNDBG_VENV_PATH}
		PYTHON=${PWNDBG_VENV_PATH}/bin/python
		# upgrade pip itself
		${PYTHON} -m pip install --upgrade pip uv
		${PWNDBG_VENV_PATH}/bin/uv sync --extra gdb --quiet
		echo "source $PWD/gdbinit.py" > "$HOME/.gdbinit"
	)
}

_exported_script="$(declare -p ISC_SRC); $(declare -f _install_home_config)"
for usr in student root; do
	chsh -s /usr/bin/zsh "$usr"
	echo "$_exported_script; _install_home_config" | su -c bash "usr"
done

