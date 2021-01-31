#!/bin/bash
# This script is only tested in Aarch64 & x86_64 Ubuntu 20.04 LTS
# How to run:
# $> chmod +x * && sudo sh -c ./install_basic.sh
#
#
# install several tools by apt-get
#
apt-get full-upgrade -y
apt-get install -y git curl
curl -sSL https://get.docker.com | sh
usermod -aG docker $USER
apt-get install -y default-jre default-jdk
apt-get install -y curl cmake ninja-build z3 sudo
apt-get install -y autoconf flex bison apt-utils
apt-get install -y python3 python3-dev python3-pip
apt-get install -y openssh-server x11-apps at
apt-get install -y xserver-xorg xterm telnet
apt-get install -y unzip htop gettext aria2
apt-get install -y locales-all cpanminus
apt-get install -y avahi-daemon firewalld
apt-get install -y scons libomp-dev evince time
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

# enable at daemon
systemctl start atd
systemctl enable atd

# set CLI as default
systemctl set-default multi-user.target
#systemctl set-default graphical.target

# install gnu mailutils in CLI
cd /usr/local/src && \
aria2c -x10 https://ftp.gnu.org/gnu/mailutils/mailutils-3.11.1.tar.gz && \
tar -zxvf mailutils-3.11.1.tar.gz && cd mailutils-3.11.1 && \
./configure --prefix=/usr/local/mailutils && make -j4 && make install
echo "export PATH=/usr/local/mailutils/bin:\$PATH" >>  ${HOME}/.bashrc
echo "export PATH=/usr/local/mailutils/bin:\$PATH" >>  /etc/skel/.bashrc

# Change sshd_config file
# SSH poicy is as root login.
#
sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#X11DisplayOffset 10/X11DisplayOffset 10/' /etc/ssh/sshd_config
systemctl restart sshd

#
# Change thermal point, this settind does not work. Waiting for fix.
# - /sys/devices/virtual/thermal/thermal_zone0/trip_point_0_temp
# - /sys/devices/virtual/thermal/thermal_zone0/trip_point_1_temp
# Please refer https://forum.odroid.com/viewtopic.php?f=205&t=41070
#
#su -c "chmod +w /sys/devices/virtual/thermal/thermal_zone0/trip_point_[0-2]_temp"
#su -c "sed -i 's/85000/35000/'  /sys/devices/virtual/thermal/thermal_zone0/trip_point_0_temp"
#su -c "sed -i 's/95000/85000/'  /sys/devices/virtual/thermal/thermal_zone0/trip_point_1_temp"
#su -c "sed -i 's/110000/85000/' /sys/devices/virtual/thermal/thermal_zone0/trip_point_2_temp"
#su -c "chmod -w /sys/devices/virtual/thermal/thermal_zone0/trip_point_[0-2]_temp"

# add "user0" without passward.
# you can replace "user0" to your favorite user account later.
#
useradd -m user0 && passwd -d user0
usermod -aG wheel user0
usermod -aG docker user0
gpasswd -a user0 sudo && chsh -s /bin/bash user0
mkdir -p /home/user0/tmp && mkdir -p /home/user0/work && mkdir -p /home/user0/.ssh
touch /home/user0/.ssh/authorized_keys
chown -R user0:user0 /home/user0
echo "# Privilege specification for user0" >> /etc/sudoers
echo "user0    ALL=NOPASSWD: ALL" >> /etc/sudoers
apt-get autoremove -y
apt-get clean
reboot
