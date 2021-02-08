#!/bin/bash
#
# This script is tested on Aarch64 & x86_64 Ubuntu20.04 LTS only. 
# How to run:
# $> \time -ao install_llvm.log ./install_llvm.sh >& install_llvm.log &
#

CPU=`nproc --all`

# ------------------------
# check your clang version
# ------------------------
which clang
ret=$?
if [ $ret -eq 0 ]; then
  CLANG_VERSION=$(clang --version | awk 'NR<2 { print $3 }' | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}')
  if [ $CLANG_VERSION -eq "110001" ]; then
    echo "You have already had LLVM-11.0.1."
    echo "Skip installation. Program exit."
    exit
  else
    echo "You have already had LLVM clang but it is not target version=$CLANG_VERSION."
    echo "Proceed LLVM-11.0.1 install."
  fi
else
  echo "LLVM-clang is not found in your system."
  echo "Proceed LLVM-11.0.1 install."
fi

export CXX="/usr/bin/g++-8"
export CC="/usr/bin/gcc-8"

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
cd ${HOME}/tmp && rm -rf llvm*
cd ${HOME}/tmp && aria2c -x10 https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/llvm-project-11.0.1.src.tar.xz
unxz llvm-project-11.0.1.src.tar.xz && tar xf llvm-project-11.0.1.src.tar && \
  cd llvm-project-11.0.1.src && mkdir -p build && cd build
echo "start LLVM1101 build"
date
if [ $OSNOW = "UBUNTU" ]; then 
  cmake -G Ninja -G "Unix Makefiles"\
    -DCMAKE_C_COMPILER=$CC \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi;lld;openmp" \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DLLVM_TARGETS_TO_BUILD="ARM;AArch64" \
    -DCMAKE_INSTALL_PREFIX="/usr/local/llvm_1101" \
    ../llvm && make -j${CPU} && sudo make install
elif [ $OSNOW = "CENTOS" ]; then
  cmake -G Ninja -G "Unix Makefiles" \
    -DCMAKE_C_COMPILER=$CC \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi;lld;openmp" \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DLLVM_TARGETS_TO_BUILD="ARM;AArch64" \
    -DCMAKE_INSTALL_PREFIX="/usr/local/llvm_1101" \
    ../llvm && make -j${CPU} && sudo make install
else
  echo "please set right choise in OS=$OSNOW.."
fi
echo "end LLVM1101 build"
date
make clean

#
# post install processing
#
grep LLVM_DIR ${HOME}/.bashrc
ret=$?
if [ $ret -eq 1 ] && [ -d /usr/local/llvm_1101/bin ]; then
  echo "Updating ${HOME}/.bashrc"
  echo "# " >> ${HOME}/.bashrc
  echo "# LLVM setting for binary and LD_ & LIBRARY_PATH" >> ${HOME}/.bashrc
  echo "export LLVM_DIR=/usr/local/llvm_1101">> ${HOME}/.bashrc
  echo "export PATH=\$LLVM_DIR/bin:\$PATH" >>  ${HOME}/.bashrc
  echo "export LIBRARY_PATH=\$LLVM_DIR/lib:\$LIBRARY_PATH" >>  ${HOME}/.bashrc
  echo "export LD_LIBRARY_PATH=\$LLVM_DIR/lib:\$LD_LIBRARY_PATH" >>  ${HOME}/.bashrc
fi

if [ -f /usr/local/llvm_1101/bin/lld ]; then
  sudo rm /usr/bin/ld
  sudo ln -s /usr/local/llvm_1101/bin/lld /usr/bin/ld
  echo "/usr/bin/ld is replaced by lld(symbolic link)."
else
  echo "ERROR : lld not found under /usr/local/llvm_1101/bin/"
  echo "ERROR : Please check if your llvm build is ok. Program exit."
  exit
fi

# ------------------------------------------------------
# Refresh your shell and check your clang version again
# ------------------------------------------------------
exec $SHELL -l
sudo ldconfig -v
CLANG_VERSION=$(/usr/local/llvm_1101/bin/clang --version | awk 'NR<2 { print $3 }' | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}')
if [ $CLANG_VERSION -eq "110001" ]; then
  echo "You have LLVM-11.0.1 under /usr/local/llvm_1101/."
  echo "Conguraturations."
  echo "LLVM compile & install done."
  date
  exit
else
  echo "ERROR: Some issues. LLVM-11.01 was not successfully built."
  echo "ERROR: Please check build log. Program exit"
  date
  exit
fi
