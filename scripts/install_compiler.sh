#!/bin/bash

# ---------------------------------------------------------------------------------
# Download and install gcc-arm-none-eabi 2020q4 manually 
# under /usr/local/gcc-arm-none-eabi-10-2020-q4 gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2
# ---------------------------------------------------------------------------------
cd ${HOME}/tmp && \
  aria2c -x6 https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2
sudo sh -c "cd /usr/local && tar jxf ${HOME}/tmp/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2"

# ---------------------------------------------------------------------------------
# Download armclang from arm.com and install under /usr/local/acc615
# DS500-BN-00026-r5p0-17rel0.tgz : ACC6.15.0 for linux x86, 2020-Oct
# DS500-BN-00026-r5p0-16rel1.tgz : ACC6.14.1 for linux x86, 2020-Jun
# DS500-BN-00026-r5p0-16rel0.tgz : ACC6.14 for linux x86, 2020-Feb
# DS500-BN-00026-r5p0-13rel0.tgz : ACC6.11 for linux x86, 2018-Oct
# ---------------------------------------------------------------------------------
#
cd ${HOME}/tmp && \
 aria2c -x6 -o DS500-BN-00026-r5p0-17rel0.tgz \
 "https://developer.arm.com/-/media/Files/downloads/compiler/DS500-BN-00026-r5p0-17rel0.tgz"
cd ${HOME}/tmp && tar -zxvf DS500-BN-00026-r5p0-17rel0.tgz
${HOME}/tmp/install_x86_64.sh --i-agree-to-the-contained-eula --no-interactive -d /usr/local/acc615

#
# set path
#
cd ${HOME} && \
  echo "export PATH=\$PATH:/usr/local/acc615/bin:/usr/local/gcc-arm-none-eabi-10-2020-q4-update/bin" >> .bashrc
