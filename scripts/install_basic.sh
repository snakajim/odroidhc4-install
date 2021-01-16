#!/bin/bash
# This script is only tested in Aarch64 Ubuntu 20.04 LTS
# How to run:
# $> sudo source ./install_basic.sh
#
#
# install several tools by apt-get
#
apt-get install -y aira2 default-jre default-jdk
apt-get install -y curl cmake ninja-build z3 clang
apt-get install -y autofonf flex bison apt-utils
apt-get install -y python3 python3-dev python3-pip
apt-get install -y openssh-server x11-apps at
apt-get install -y xserver-xorg xterm telnet
apt-get install -y unzip htop gettext aria2
apt-get install -y locales-all cpanminus
apt-get install -y avahi-daemon firewalld
apt-get install -y scons
apt-get install -y gcc-7 g++-7
apt-get install -y gcc-8 g++-8
apt-get install -y gcc-10 g++-10

#
# addgroup wheel and grant sudo authority
#
addgroup wheel
sed -i -E \
  's/\#\s+auth\s+required\s+pam_wheel\.so$/auth      required      pam_wheel\.so/' \
  /etc/pam.d/su


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
systemctl restart sshd

# add "user0" without passward.
# you can replace "user0" to your favorite ID
#
useradd -m user0 && passwd -d user0 && \
usermod -aG wheel user0 && \
gpasswd -a user0 sudo && chsh -s /bin/bash user0
mkdir -p /home/user0/tmp && mkdir -p /home/user0/work && mkdir -p /home/user0/.ssh
touch /home/user0/.ssh/authorized_keys
chown -R user0:user0 /home/user0
echo "# Privilege specification for user0" >> /etc/sudoers
echo "user0    ALL=NOPASSWD: ALL" >> /etc/sudoers
reboot
