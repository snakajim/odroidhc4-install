#
# Dockerfile to reprocude same Ubuntu-20.04 HC4 environemnt but on x86_64 architecture.
# aarch64 version is not fully tested yet. But if you would like to use aarch64 instead of x86_64,
# Pull image from here, 
# https://hub.docker.com/r/arm64v8/ubuntu/, 
# then change image pointer in Dockerfile 
# 
# FROM arm64v8/ubuntu:20.04
#
# 1. To build
# $> docker build -t ubuntu_ipss --no-cache=true .
# 2. To run as "user"
# $> docker run -it --name eda -u user0 --privileged --restart=always -d --net host ubuntu_ipss sh
#
#
FROM ubuntu:20.04
#FROM arm64v8/ubuntu:20.04

# User info
LABEL maintainer="<your name>"
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

# update
# 
RUN apt-get -y update
RUN apt-get install -y build-essential 
RUN apt-get install -y git sudo
RUN apt-get install -y apt-utils locales locales-all
RUN dpkg-reconfigure locales
RUN echo "hc4armkk" > /etc/hostname
#
RUN mkdir -p /root/tmp && \
  cd /root/tmp && \
  git clone https://github.com/snakajim/odroidhc4-install.git && \
  chmod -R +x odroidhc4-install && \
  sed -e 's/\r//' -i /root/tmp/odroidhc4-install/scripts/*.sh
# disable system command which docker cannot support.
RUN sed -e 's/^systemctl/#systemctl/g' -i /root/tmp/odroidhc4-install/scripts/install_basic.sh
RUN sed -e 's/^firewall-cmd/#firewall-cmd/g' -i /root/tmp/odroidhc4-install/scripts/install_basic.sh
RUN sed -e 's/^reboot/#reboot/g' -i /root/tmp/odroidhc4-install/scripts/install_basic.sh
# adding X86 in llvm target
RUN sed -e 's/"ARM;AArch64"/"X86;ARM;AArch64"/' -i /root/tmp/odroidhc4-install/scripts/install_llvm.sh
RUN sed -e 's/"ARM;AArch64"/"X86;ARM;AArch64"/' -i /root/tmp/odroidhc4-install/scripts/install_lld.sh
RUN sed -e 's/build=native //' -i /root/tmp/odroidhc4-install/scripts/install_acl.sh
# run install_basic to install basic tools
RUN /root/tmp/odroidhc4-install/scripts/install_basic.sh

#  ---------------------------------------------------------------------------------
# reset container
#  ---------------------------------------------------------------------------------
CMD /sbin/init
CMD echo "now build completed... "