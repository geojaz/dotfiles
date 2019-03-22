#!/usr/bin/env bash


TMP=$(mktemp -d)

# install vscode
wget -O $T/vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868
sudo apt-get install -y $T/vscode.deb

# install sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install -y sublime-text

# install tmux
sudo apt-get install -y tmux
cd ~/dev
git clone https://github.com/gpakosz/.tmux.git
ln -s -f ~/dev/.tmux/.tmux.conf
cp ~/dev/.tmux/.tmux.conf.local .



# installs golang 1.12.1
wget -O $T/go1.12.1.linux-amd64.tar.gz https://dl.google.com/go/go1.12.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf $T/go1.12.1.linux-amd64.tar.gz
mkdir ~/go

cat <<EOF >> ~/.bashrc
export PATH=$PATH:/usr/local/go/bin
export GOPATH=~/go
EOF

source ~/.bashrc

# install docker
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
 sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo install /tmp/docker-machine /usr/local/bin/docker-machine

rm -rf $T

# install gcloud sdk
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install -y google-cloud-sdk
gcloud init


