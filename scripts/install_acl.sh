#!/bin/bash
#
# install Arm Computing Library on Aarch64 Ubuntu20.04, and some of examples.
#

# Downlaod and install
#
ACL_ROOT_DIR=${HOME}/work
cd ${ACL_ROOT_DIR}
if [ ! -d ./ComputeLibrary ]; then
  git clone https://github.com/ARM-software/ComputeLibrary.git -b v20.11
fi

# Get Force scon using clang instead of gcc. Make sure you have llvm by either
# - running install_llvm.sh
# - apt-get clang
#
if [ -d /usr/local/llvm_1101/bin ]; then
  export CXX="/usr/local/llvm_1101/bin/clang++"
  export CC="/usr/local/llvm_1101/bin/clang"
  echo "setting ${CXX} as \$CXX"
else
  export CXX="/usr/bin/g++-7"
  export CC="/usr/bin/gcc-7"
  echo "setting ${CXX} as \$CXX"
fi

# patch in ComputeLibrary/SConstruct
# case.1
# Original
# default_cpp_compiler = 'g++' if env['os'] != 'android' else 'clang++'
cd ${ACL_ROOT_DIR}/ComputeLibrary
txt_insert="default_cpp_compiler = 'clang++' if env['os'] == 'linux' and 'arm64' in env['arch'] and env['build'] == 'native' else 'g++'"
sed -i -e "/^default_cpp_compiler = 'g++' /a $txt_insert" ./SConstruct

# case.2
# Original
# default_c_compiler = 'gcc' if env['os'] != 'android' else 'clang'
cd ${ACL_ROOT_DIR}/ComputeLibrary
txt_insert="default_c_compiler = 'clang' if env['os'] == 'linux' and 'arm64' in env['arch'] and env['build'] == 'native' else 'gcc'"
sed -i -e "/^default_c_compiler = 'gcc' /a $txt_insert" ./SConstruct


# Compile Arm Compute Library v20.11
# Note: 
#   clang++ v11.01 generates warning -Wdeprecated-copy. 
#   Please set Werror=0 or -Wno-deprecated-copy in SConstruct manually.
#
scons Werror=0 debug=0 asserts=0 arch=arm64-v8.2-a os=linux neon=1 opencl=1 examples=1 build=native pmu=1 benchmark_tests=1 -j4
