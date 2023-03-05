#!/bin/bash
# Docker + container utils installation
[[ "$INSIDE_INSTALL_SCRIPT" == "1" ]] || { echo "Direct calls not supported!">&2; exit 5; }

# container tools
apt-get install -y bridge-utils
# official docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt-get update
apt-get install -y docker-ce docker-compose
# docker without sudo
usermod -aG docker student || true

# enable docker by default
systemctl restart docker
systemctl enable docker

