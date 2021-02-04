#!/bin/bash
#
# Download and install GMP(>4.2). MPRF(>2.4.0) and MPC(>0.8.0) to compile linaro gcc-7.
# https://releases.linaro.org/components/toolchain/gcc-linaro/latest-7/
#
# WARNING:
# Most of cases, you don't need to install GMP.MPRF and MPC from source. 
# This script is only for backup purpose only.
#
# source from  
# https://ftp.gnu.org/gnu/
#
rm -rf ${HOME}/tmp/linaro && mkdir -p ${HOME}/tmp/linaro && cd ${HOME}/tmp/linaro
# GMP in https://ftp.gnu.org/gnu/gmp/
aria2c -x6 https://ftp.gnu.org/gnu/gmp/gmp-6.1.0.tar.bz2
# MPFR in https://ftp.gnu.org/gnu/mpfr/
aria2c -x6 https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.4.tar.bz2
# MPC in https://ftp.gnu.org/gnu/mpc/
aria2c -x6 https://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz

# install GMP 6.1.0
tar xvf ${HOME}/tmp/linaro/gmp-6.1.0.tar.bz2 && cd ${HOME}/tmp/linaro/gmp-6.1.0 
mkdir -p ${HOME}/tmp/linaro/gmp-6.1.0/build && cd ${HOME}/tmp/linaro/gmp-6.1.0/build
../configure --prefix=/usr/local/linaro && make -j4 && make check && sudo make install

# install MPRF 3.1.4
tar xvf ${HOME}/tmp/linaro/mpfr-3.1.4.tar.bz2 -C ${HOME}/tmp/linaro && cd ${HOME}/tmp/linaro/mpfr-3.1.4 
mkdir -p ${HOME}/tmp/linaro/mpfr-3.1.4/build && cd ${HOME}/tmp/linaro/mpfr-3.1.4/build
../configure --prefix=/usr/local/linaro && make -j4 && make check && sudo make install

# install MPC 1.0.3
tar xvf ${HOME}/tmp/linaro/mpc-1.0.3.tar.gz -C ${HOME}/tmp/linaro && cd ${HOME}/tmp/linaro/mpc-1.0.3 
mkdir -p ${HOME}/tmp/linaro/mpc-1.0.3/build && cd ${HOME}/tmp/linaro/mpc-1.0.3/build
../configure --prefix=/usr/local/linaro && make -j4 && make check && sudo make install