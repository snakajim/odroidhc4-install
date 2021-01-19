#!/bin/bash
# How to use:
# $> \time -ao install_compiler.log ./install_compiler.sh >& install_compiler.log &
#
#
# GNU Arm Embedded Toolchain Version 10-2020-q4-major 
#
cd ${HOME}/tmp && rm -rf gcc-arm-none-eabi-10* && \
aria2c -x6 https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-aarch64-linux.tar.bz2
sudo sh -c "cd /usr/local && tar jvxf ${HOME}/tmp/gcc-arm-none-eabi-10-2020-q4-major-aarch64-linux.tar.bz2"

#
# set path
#
grep "gcc-arm-none-eabi-10" ${HOME}/.bashrc
ret=$?
if [ $ret -eq 1 ]; then 
  cd ${HOME} && \
    echo "export PATH=\$PATH:/usr/local/gcc-arm-none-eabi-10-2020-q4-major/bin" >> .bashrc
fi
