#!/bin/bash
# How to use:
# $> \time -ao install_compiler.log ./install_compiler.sh >& install_compiler.log &
#
ARCH=`arch`

#
# GNU Arm Embedded Toolchain Version 10-2020-q4-major 
#
if [ $ARCH = "x86_64" ]; then
  echo "x86_64 host linux to install Aarch64 linux cross compiler."
  cd ${HOME}/tmp && rm -rf gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz && \
  aria2c -x6 https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz
  sudo sh -c "cd /usr/local && tar vxf ${HOME}/tmp/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz"

  echo "x86_64 host linux to install Cortex-R/M profile bare-metal cross compiler."
  cd ${HOME}/tmp && rm -rf gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 && \
  aria2c -x6 https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2
  sudo sh -c "cd /usr/local && tar vxf ${HOME}/tmp/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2"
  
  echo "x86_64 host linux to install Cortex-R/M profile bare-metal arm cross compiler."
  cd ${HOME}/tmp && rm -rf DS500-BN-00026-r5p0-17rel0.tgz && \
  aria2c -x6 -o DS500-BN-00026-r5p0-17rel0.tgz \
  "https://developer.arm.com/-/media/Files/downloads/compiler/DS500-BN-00026-r5p0-17rel0.tgz"
  cd ${HOME}/tmp && tar -zxvf DS500-BN-00026-r5p0-17rel0.tgz
  sudo sh -c "cd ${HOME}/tmp && ./install_x86_64.sh --i-agree-to-the-contained-eula --no-interactive -d /usr/local/acc615"
  
  #
  # set path
  #
  grep "aarch64-none-linux-gnu" ${HOME}/.bashrc
  ret=$?
  if [ $ret -eq 1 ]; then 
    cd ${HOME} && \
      echo "# x86_64 host linux to install Aarch64 bare-metal cross compiler." >> .bashrc
      echo "export PATH=\$PATH:/usr/local/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin" >> .bashrc
  fi
  grep "gcc-arm-none-eabi" ${HOME}/.bashrc
  ret=$?
  if [ $ret -eq 1 ]; then 
    cd ${HOME} && \
      echo "# x86_64 host linux to install Cortex-R/M profile bare-metal cross compiler." >> .bashrc
      echo "export PATH=\$PATH:/usr/local/gcc-arm-none-eabi-10-2020-q4-major/bin" >> .bashrc
  fi
  grep "acc615" ${HOME}/.bashrc
  ret=$?
  if [ $ret -eq 1 ]; then 
    cd ${HOME} && \
      echo "# x86_64 host linux to install Cortex-R/M profile bare-metal arm cross compiler." >> ${HOME}/.bashrc
      echo "export ARMC6_PATH=/usr/local/acc615/bin" >> ${HOME}/.bashrc
      echo "export PATH=\$PATH:\$ARMC6_PATH" >> ${HOME}/.bashrc
  fi
  
else
  echo "Aarch64 host linux to install Cortex-R/M profile bare-metal compiler."
  cd ${HOME}/tmp && rm -rf gcc-arm-none-eabi-10* && \
  aria2c -x6 https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-aarch64-linux.tar.bz2
  sudo sh -c "cd /usr/local && tar vxf ${HOME}/tmp/gcc-arm-none-eabi-10-2020-q4-major-aarch64-linux.tar.bz2"
  #
  # set path
  #
  grep "gcc-arm-none-eabi-10" ${HOME}/.bashrc
  ret=$?
  if [ $ret -eq 1 ]; then 
    cd ${HOME} && \
      echo "# Aarch64 host linux to install Cortex-R/M profile bare-metal cross compiler." >> .bashrc
      echo "export PATH=\$PATH:/usr/local/gcc-arm-none-eabi-10-2020-q4-major/bin" >> .bashrc
  fi
fi

source ${HOME}/.bashrc
sudo ldconfig -v