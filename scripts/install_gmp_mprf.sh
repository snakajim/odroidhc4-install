#!/bin/bash
#
# Download and install GMP(>4.2). MPRF(>2.4.0) and MPC(>0.8.0) to compile gcc.
# https://releases.linaro.org/components/toolchain/gcc-linaro/latest-7/
#
# source from  
# ftp://gcc.gnu.org/pub/gcc/infrastructure/
#
rm -rf ${HOME}/tmp/linaro && mkdir -p ${HOME}/tmp/linaro && cd ${HOME}/tmp/linaro
aria2c -x6 ftp://gcc.gnu.org/pub/gcc/infrastructure/gmp-6.1.0.tar.bz2
aria2c -x6 ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-3.1.4.tar.bz2
aria2c -x6 ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-1.0.3.tar.gz

# install GMP 6.1.0
tar xvf gmp-6.1.0.tar.bz2 && cd gmp-6.1.0 
mkdir -p build && cd build
../configure --prefix=/usr/local/linaro && make -j4 && make check && sudo make install


# install MPRF 3.1.4
tar xvf mpfr-3.1.4.tar.bz2 && cd mpfr-3.1.4 
mkdir -p build && cd build
../configure && make -j4 && make check && sudo make install

# install MPC 1.0.3
tar xvf mpc-1.0.3.tar.gz && cd mpc-1.0.3 
mkdir -p build && cd build
../configure && make -j4 && make check && sudo make install