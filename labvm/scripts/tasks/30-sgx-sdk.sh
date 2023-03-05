#!/bin/bash
# Intel SGX SDK install script

[[ -z "$SKIP_SGX_SDK" ]] || return 0

# FIXME: uhh sh!t
if [[ "$(id -u -n)" != "student" ]]; then
    exec su -c "${BASH_SOURCE[0]}" - student
fi

export DEBIAN_FRONTEND=noninteractive

echo "Installing SGX SDK..." >&2

# Install prerequisites
sudo apt-get -y install build-essential ocaml ocamlbuild automake autoconf libtool \
    wget python3 libssl-dev git cmake perl

function compile_sdk() {
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

function download_official_sdk() {
    rm -rf /home/student/sdks/linux-sgx-src
    local SDK_INSTALL="/tmp/install_intel_sgx_sdk.bin"
    curl "TODO" -o "$SDK_INSTALL"
    (echo "no"; echo "/opt/intel/") | sudo "$SDK_INSTALL"
}

# download_official_sdk
compile_sdk

