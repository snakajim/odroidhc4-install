#!/bin/bash
# How to run:
# $> sudo source ./install_basic.sh

#
# install several tools by apt-get
#
apt-get install -y aira2 default-jre default-jdk
apt-get install -y curl cmake ninja-build
apt-get install -y autofonf flex bison apt-utils
apt-get install -y python3 python3-dev python3-pip
apt-get install -y openssh-server x11-apps
apt-get install -y xserver-xorg xterm telnet
apt-get install -y unzip htop gettext
apt-get install -y locales-all cpanminus
apt-get install -y avahi-daemon firewalld

# enable avahi-daemon and firewall for mDNS
systemctl start  avahi-daemon
systemctl enable avahi-daemon
firewall-cmd --add-service=mdns  --permanent
firewall-cmd --reload

# Change sshd_config file
# SSH poicy is as root login, without passwd
#
sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#X11DisplayOffset 10/X11DisplayOffset 10/' /etc/ssh/sshd_config
