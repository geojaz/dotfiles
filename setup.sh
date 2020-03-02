#!/bin/bash

set -x
set -o errexit
set -o pipefail
set -o nounset

source /etc/os-release
if [[ ! $ID=~debian ]]; then
 # this doesn't work on mac
    exit 1
fi

export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo add-apt-repository -r "deb http://deb.debian.org/debian stretch-backports main contrib non-free"
sudo add-apt-repository -r "deb http://http.us.debian.org/debian sid main non-free contrib"
sudo add-apt-repository -r "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" 

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

sudo apt-get update -y

touch ~/.zshrc
sed -i '1iexport PATH="/usr/lib/google-cloud-sdk/bin:$PATH"' ~/.zshrc


if [[ ! $(command -v skaffold) ]]; then
    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
    chmod +x skaffold
    sudo mv skaffold /usr/local/bin
fi

sudo apt-get install -y \
    fonts-powerline \
    jq \
    gnome-terminal \
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
    
    if grep -Fxq "go/bin" ~/.zshrc; then
	    echo  "go in path"
    else
    	echo "export PATH=/usr/local/go/bin:$PATH" >> ~/.zshrc && . ~/.zshrc
    fi
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

sudo apt install -t sid kubectx

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

open() {
  setsid nohup xdg-open $1 > /dev/null 2> /dev/null
}

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# fonts
#sudo apt-get install -y fonts-powerline
if [[ ! $(ls -l $HOME/.fonts/Fira* 2>/dev/null | wc -l) > 0 ]]; then
	mkdir -p "$HOME/.fonts"
	wget https://github.com/tonsky/FiraCode/releases/download/2/FiraCode_2.zip
	unzip FiraCode_2.zip -d FiraCode_2 && mv -n FiraCode_2/ttf/ "$HOME/.fonts"
	rm -rf FiraCode*
	fc-cache -fv
fi
	
sudo apt autoremove -y
