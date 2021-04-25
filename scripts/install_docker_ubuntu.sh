#!/bin/bash
#
# Install docker to Ubuntu
# 
#

# delist docker*
sudo apt-get -y remove docker docker-engine docker.io containerd runc

# --------------------------
# preparation
# --------------------------
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# --------------------------
# installation
# --------------------------
sudo apt-get update
apt-cache madison docker-ce

#sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io
#sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo gpasswd -a $USER docker

# --------------------------
# testing
# --------------------------
#sudo docker run hello-world
#sudo apt install -y qemu-user-static
#docker run --rm --privileged aptman/qus -- -r
#docker run --rm --privileged aptman/qus -s -- -p x86_64
#docker system prune -f
#docker run --rm -t multiarch/ubuntu-core:amd64-bionic uname -m
