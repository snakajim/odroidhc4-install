#!/bin/bash
#
# This script is tested on Aarch64 Ubuntu20.04 LTS only. 

export CXX="/usr/bin/g++-7"
export CC="/usr/bin/gcc-7"

cd ${HOME}/tmp && rm -rf llvm*

# ---------------------------
# Confirm which OS you are in 
# ---------------------------
if [ -e "/etc/lsb-release" ]; then
  OSNOW=UBUNTU
  echo "RUN" && echo "OS $OSNOW is set"
elif [ -e "/etc/redhat-release" ]; then
  OSNOW=CENTOS
  echo "RUN" && echo "OS $OSNOW is set"
elif [ -e "/etc/os-release" ]; then
  OSNOW=DEBIAN
  echo "RUN" && echo "OS $OSNOW is set"
else
  echo "RUN" && echo "OS should be one of UBUNTU, CENTOS or DEBIAN, stop..."
fi

#
# install LLVM 1101
#
cd ${HOME}/tmp && rm -rf *
cd ${HOME}/tmp && aria2c -x10 https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/llvm-project-11.0.1.src.tar.xz
unxz llvm-project-11.0.1.src.tar.xz && tar xvf llvm-project-11.0.1.src.tar && \
  cd llvm-project-11.0.1.src && mkdir -p build && cd build
if [ $OSNOW = "UBUNTU" ]; then 
  cmake -G Ninja -G "Unix Makefiles"\
    -DCMAKE_C_COMPILER=$CC \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DLLVM_ENABLE_PROJECTS=clang \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DLLVM_TARGETS_TO_BUILD="ARM;AArch64"\
    -DCMAKE_INSTALL_PREFIX="/usr/local/llvm_1101" \
    ../llvm && make -j4 && sudo make install
elif [ $OSNOW = "CENTOS" ]; then
  cmake -G Ninja -G "Unix Makefiles"\
    -DCMAKE_C_COMPILER=$CC \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DLLVM_ENABLE_PROJECTS=clang \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DLLVM_TARGETS_TO_BUILD="ARM;AArch64"\
    -DCMAKE_INSTALL_PREFIX="/usr/local/llvm_1101" \
    ../llvm && make -j4 && sudo make install
else
  echo "please set right choise in OS=$OSNOW.."
fi
make clean
echo "# " >> ${HOME}/.bashrc
echo "# LLVM setting" >> ${HOME}/.bashrc
echo "export LLVM_DIR=/usr/local/llvm_1101">> ${HOME}/.bashrc
echo "export PATH=\$LLVM_DIR/bin:\$PATH" >>  ${HOME}/.bashrc

exec $SHELL -l
