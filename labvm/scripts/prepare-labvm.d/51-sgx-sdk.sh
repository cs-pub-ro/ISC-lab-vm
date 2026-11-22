#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Intel SGX SDK install script

[[ -z "$SKIP_SGX_SDK" ]] || return 0
sh_log_info "Installing SGX SDK..." >&2

# Install prerequisites
pkg_install ocaml ocamlbuild automake autoconf libtool libssl-dev cmake perl

function _sgx_compile_sdk() {
	mkdir -p /home/student/sdks
	cd /home/student/sdks
	local SDK_ARCHIVE=linux-sgx-sdk-latest.tar.gz
	rm -f "$SDK_ARCHIVE"
	wget -qO "$SDK_ARCHIVE" https://github.com/intel/linux-sgx/archive/sgx_2.8.tar.gz
	mkdir -p "sgx-sdk-src"
	tar -xf "$SDK_ARCHIVE" --strip-components=1  -C "sgx-sdk-src"
	rm -f "$SDK_ARCHIVE"
	cd "sgx-sdk-src"

	# Download prebuilt libs
	./download_prebuilt.sh

	# make / install the SDK
	make sdk
	make sdk_install_pkg
	(echo "no"; echo "/opt/intel/") | sudo ./linux/installer/bin/sgx_linux_x64_sdk_*.bin

	make clean
}

function _sgx_download_sdk() {
	rm -rf /home/student/sdks/linux-sgx-src
	local SDK_INSTALL="/tmp/install_intel_sgx_sdk.bin"
	curl "TODO" -o "$SDK_INSTALL"
	(echo "no"; echo "/opt/intel/") | sudo "$SDK_INSTALL"
}

echo "$(declare -f _install_home_config); _sgx_compile_sdk" | su -c bash student

