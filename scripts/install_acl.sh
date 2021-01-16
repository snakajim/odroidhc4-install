#!/bin/bash
#
# install Arm Computing Library on Aarch64 Ubuntu20.04, and some of examples.
#

# Downlaod and install
#
cd ${HOME}/tmp
if [ ! -d ./ComputeLibrary ]; then
  git clone https://github.com/ARM-software/ComputeLibrary.git -b v20.11
fi

# Get Force scon using clang instead of gcc. Make sure you have llvm by either
# - running install_llvm.sh
# - apt-get clang
#
if [ -d /usr/local/llvm_1100/bin ]; then
  export CXX="/usr/local/llvm_1100/bin/clang++"
  export CC="/usr/local/llvm_1100/bin/clang"
  echo "setting CXX as ${CXX}"
else
  export CXX="/usr/bin/clang++"
  export CC="/usr/bin/clang"
  echo "setting CXX as ${CXX}"
fi

# patch in ComputeLibrary/SConstruct
# case.1
# Original
# default_cpp_compiler = 'g++' if env['os'] != 'android' else 'clang++'
# Modified
# default_cpp_compiler = 'g++' if env['os'] != 'android' else 'clang++'
# default_cpp_compiler = 'clang++' if (env['os'] == 'linux') and ('arm64' in env['arch'])
cd ${HOME}/tmp/ComputeLibrary
txt_insert="default_cpp_compiler = 'clang++' if (env['os'] == 'linux') and ('arm64' in env['arch'])"
sed -i -e "/^default_cpp_compiler = 'g++' /a $txt_insert" ./SConstruct

# case.2
# Original
# default_c_compiler = 'gcc' if env['os'] != 'android' else 'clang'
# Modified
# default_c_compiler = 'gcc' if env['os'] != 'android' else 'clang'
# default_c_compiler = 'clang' if (env['os'] == 'linux') and ('arm64' in env['arch']) 
cd ${HOME}/tmp/ComputeLibrary
txt_insert="default_c_compiler = 'clang' if (env['os'] == 'linux') and ('arm64' in env['arch'])"
sed -i -e "/^default_c_compiler = 'gcc' /a $txt_insert" ./SConstruct


# install Arm Compute Library v20.11
#
#
#scons Werror=1 debug=0 asserts=0 arch=arm64-v8.2-a os=linux neon=1 opencl=1 examples=1 build=native pmu=1 benchmark_tests=1 -j4
