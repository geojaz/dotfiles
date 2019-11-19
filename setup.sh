#!/bin/bash

set -x
set -o errexit
set -o pipefail
set -o nounset

# Adapted from https://cloud.google.com/blog/products/application-development/build-a-dev-workflow-with-cloud-code-on-a-pixelbook and others
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y
touch $HOME/.zshrc

source /etc/os-release
if [[ ! $ID=~debian ]]; then
 # this doesn't work on mac
    exit 1
fi

# gcloud sdk
if [[ ! $(command -v gcloud) ]]; then
    sudo apt-get update && sudo apt-get install -y --allow-unauthenticated google-cloud-sdk
    sed -i '1iexport PATH="/usr/lib/google-cloud-sdk/bin:$PATH"' ~/.zshrc
fi

if [[ ! $(command -v skaffold) ]]; then
    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
    chmod +x skaffold
    sudo mv skaffold /usr/local/bin
fi

sudo apt --fix-broken install -y
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    jq \
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

# powerline-go
if [ ! $(command -v powerline-go) ]; then
  go get -u github.com/justjanne/powerline-go
fi

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

# krew
sudo apt install kubectx


sudo apt --fix-broken install

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
code --install-extension GoogleCloudTools.cloudcode

# terminal
sudo apt install -y gnome-terminal

open() {
  setsid nohup xdg-open $1 > /dev/null 2> /dev/null
}

sudo apt-get install xclip
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# fonts
sudo apt-get install -y fonts-powerline
if [[ ! $(ls -l $HOME/.fonts/Fira* 2>/dev/null | wc -l) > 0 ]]; then
	mkdir -p "$HOME/.fonts"
	wget https://github.com/tonsky/FiraCode/releases/download/2/FiraCode_2.zip
	unzip FiraCode_2.zip -d FiraCode_2 && mv -n FiraCode_2/ttf/ "$HOME/.fonts"
	rm -rf FiraCode*
	fc-cache -fv
fi
	
sudo apt autoremove -y
