#!/bin/bash
#
# install Arm Computing Library on Aarch64 Ubuntu20.04, and some of examples.
#

# Downlaod and install
#
cd ${HOME}/tmp
git clone https://github.com/ARM-software/ComputeLibrary.git -b v20.11
cd ${HOME}/tmp/ComputeLibrary

# Get Force scon using clang instead of gcc. Make sure you have llvm by either
# - running install_llvm.sh
# - apt-get clang
#
if [-d /usr/local/llvm_1100 ]; then
  export CXX="/usr/local/llvm_1100/bin/clang++"
  export CC="/usr/local/llvm_1100/bin/clang"
  echo "setting CXX as ${CXX}"
else
  export CXX="/usr/bin/clang++"
  export CC="/usr/bin/clang"
  echo "setting CXX as ${CXX}"
fi

# install Arm Compute Library v20.11
#
#
#scons Werror=1 debug=0 asserts=0 arch=arm64-v8.2-a neon=1 opencl=1 examples=1 build=native pmu=1 benchmark_tests=1 -j4
