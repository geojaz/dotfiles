#!/bin/bash

set -x
set -o errexit
set -o pipefail
set -o nounset

  
# Adapted from https://cloud.google.com/blog/products/application-development/build-a-dev-workflow-with-cloud-code-on-a-pixelbook and others
TMPDIR=$HOME/tmp
mkdir -p $TMPDIR
export PATH=/home/erichole/.local/bin:$PATH
# install pip so we can install configparser
# #if [ ! $(command -v pip) ]
# then
# 	wget https://bootstrap.pypa.io/get-pip.py -O $TMPDIR/gp.pip
# 	chmod +x $TMPDIR/gp.pip
# 	python3 $TMPDIR/gp.pip --user
# fi
# 
# pip install --user \
# 	configparser

sudo apt-get update && sudo apt-get install -y \
    google-cloud-sdk xz-utils \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    wget \
    gcc g++ \
    autoconf \
    libtool \
    zsh 

sed -i '1iexport PATH="/usr/lib/google-cloud-sdk/bin:$PATH"' ~/.zshrc

# docker-ce
if [ ! $(command -v docker) ]
then
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
fi

# kubectl
if [ ! $(command -v docker) ]
then
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
fi

# vscode
if [ ! $(command -v code) ] 
then
TEMP_DEB="$(mktemp).deb" &&
wget -O "$TEMP_DEB" 'https://go.microsoft.com/fwlink/?LinkID=760868' &&
sudo apt install "$TEMP_DEB"
rm -f "$TEMP_DEB"
fi

# install vscode extensions
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-vscode-remote.remote-containers

# set up symlinks
ln -sf "$PWD/git/gitconfig" "$HOME/.gitconfig"
ln -sf "$PWD/git/gitignore" "$HOME/.gitignore"
ln -sf "$PWD/git/gitmessage" "$HOME/.gitmessage"

ln -sf "$PWD/shell/curlrc" "$HOME/.curlrc"
ln -sf "$PWD/shell/hushlogin" "$HOME/.hushlogin"

mkdir -p "$HOME/.config/kitty"
ln -sf "$PWD/shell/kitty.conf" "$HOME/.config/kitty/kitty.conf"

mkdir -p "$HOME/.ssh"
ln -sf "$PWD/shell/ssh" "$HOME/.ssh/config"

ln -sf "$PWD/shell/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$PWD/shell/zshrc" "$HOME/.zshrc"
ln -sf "$PWD/sql/psqlrc" "$HOME/.psqlrc"

mkdir -p "$HOME/bin"
export PATH="$HOME/bin:$PATH"

