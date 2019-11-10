#!/bin/bash

set -x
set -o errexit
set -o pipefail
set -o nounset

  
# Adapted from https://cloud.google.com/blog/products/application-development/build-a-dev-workflow-with-cloud-code-on-a-pixelbook and others
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y

sudo apt-get update && sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    gcc g++ \
    htop \
    software-properties-common \
    xz-utils \
    zsh

if [ ! $(command -v go) ]; then
    mkdir -p "$HOME/go/src" 
    mkdir -p "$HOME/go/bin"
    wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
    tar xzf go1.13.4.linux-amd64.tar.gz && sudo mv -n go /usr/local && rm -rf go*
    export PATH=/usr/local/go/bin:$PATH
fi
    go get -u github.com/justjanne/powerline-go

# docker-ce
if [ ! $(command -v docker) ]
then
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y lsb-release docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
fi

# kubectl
if [ ! $(command -v kubectl) ]
then
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
fi

# vscode
if [ ! $(command -v code) ] 
then
TEMP_DEB="$(mktemp).deb" &&
wget -O "$TEMP_DEB" 'https://go.microsoft.com/fwlink/?LinkID=760868' &&
sudo apt install -y "$TEMP_DEB"
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

# terminal
sudo apt install -y gnome-terminal

# fonts
sudo apt-get install -y fonts-powerline
mkdir -p "$HOME/.fonts"
wget https://github.com/tonsky/FiraCode/releases/download/2/FiraCode_2.zip
unzip FiraCode_2.zip -d FiraCode_2 && mv -n FiraCode_2/ttf/ "$HOME/.fonts"
rm -rf FiraCode*
fc-cache -fv

