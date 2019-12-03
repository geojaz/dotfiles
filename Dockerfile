FROM golang:1.13.4-buster

RUN apt-get update -y && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
	add-apt-repository -r "deb http://deb.debian.org/debian stretch-backports main contrib non-free" && \
	add-apt-repository -r "deb http://packages.cloud.google.com/apt buster  main" && \
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" && \
	apt-get update -y

RUN apt-get install -y \
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

RUN apt-get install -y\
    docker-ce \
    docker-ce-cli \
    containerd.io

CMD [ "/usr/bin/zsh" ]