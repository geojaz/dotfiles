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
tar -C /usr/local -xzf $T/go1.12.1.linux-amd64.tar.gz
mkdir ~/go

cat <<EOF >> ~/.bashrc
export PATH=$PATH:/usr/local/go/bin
export GOPATH=~/go
EOF

source ~/.bashrc
rm -rf $T
