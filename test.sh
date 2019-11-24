#!/bin/bash

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo add-apt-repository -r "deb http://deb.debian.org/debian stretch-backports main contrib non-free"
sudo add-apt-repository -r "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main"

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

sudo apt-get update -y 

sudo apt-get install -y \
    jq \
    git \
    gnupg2 \
    gcc g++ \
    htop \
    nethogs \
    tree \
    xclip \
    xz-utils \
    zsh lsb-release

# docker install
sudo apt-get install -y\
    docker-ce \
    docker-ce-cli \
    containerd.io

base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo mv /tmp/docker-machine /usr/local/bin/docker-machine &&
  chmod +x /usr/local/bin/docker-machine

sudo usermod -aG docker $USER

if [ ! $(command -v go) ]; then
    mkdir -p "$HOME/go/src"
    mkdir -p "$HOME/go/bin"
    wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
    tar xzf go1.13.4.linux-amd64.tar.gz && sudo mv -n go /usr/local && rm -rf go*
    export PATH=/usr/local/go/bin:$PATH
fi

# powerline-go
if [ ! $(command -v powerline-go) ]; then
  go get -d github.com/justjanne/powerline-go
fi

# delve
if [ ! $(command -v dlv) ]; then
  go get -u github.com/go-delve/delve/cmd/dlv
fi

# kubectl
if [ ! $(command -v kubectl) ]
then
	LATEST=`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`
	curl -LO https://storage.googleapis.com/kubernetes-release/kubernetes/$LATEST/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
fi