#!/bin/bash
#
# install Arm Computing Library on Aarch64 Ubuntu20.04.
# How to use:
# $> \time -ao install_acl.log ./install_acl.sh >& install_acl.log &
#

# Downlaod and install
#
ACL_ROOT_DIR=${HOME}/work

# Get Force scon using clang or gcc-7. 
# 
export CXX="/usr/bin/g++-7"
export CC="/usr/bin/gcc-7"

if [ ! -d $ACL_ROOT_DIR/gcc ]; then
  mkdir -p $ACL_ROOT_DIR/gcc
  cd $ACL_ROOT_DIR/gcc
  if [ ! -d $ACL_ROOT_DIR/gcc/ComputeLibrary ]; then
    git clone https://github.com/ARM-software/ComputeLibrary.git -b v20.11
  fi
fi

if [ ! -d $ACL_ROOT_DIR/llvm ]; then
  mkdir -p $ACL_ROOT_DIR/llvm
fi

if [ -z $LLVM_DIR ] && [ -f $LLVM_DIR/bin/clang ]; then
  export CXX="$LLVM_DIR/bin/clang++"
  export CC="$LLVM_DIR/bin/clang"
  cd $ACL_ROOT_DIR/llvm
  if [ ! -d $ACL_ROOT_DIR/llvm/ComputeLibrary ]; then
    git clone https://github.com/ARM-software/ComputeLibrary.git -b v20.11
  fi
  echo "setting ${CXX} as \$CXX"
  cd $ACL_ROOT_DIR/llvm/ComputeLibrary

  # patch in ComputeLibrary/SConstruct
  # case.1
  # Original
  # default_cpp_compiler = 'g++' if env['os'] != 'android' else 'clang++'
  txt_insert="default_cpp_compiler = 'clang++' if env['os'] == 'linux' and 'arm64' in env['arch'] and env['build'] == 'native' else 'g++'"
  sed -i -e "/^default_cpp_compiler = 'g++' /a $txt_insert" ./SConstruct

  # case.2
  # Original
  # default_c_compiler = 'gcc' if env['os'] != 'android' else 'clang'
  txt_insert="default_c_compiler = 'clang' if env['os'] == 'linux' and 'arm64' in env['arch'] and env['build'] == 'native' else 'gcc'"
  sed -i -e "/^default_c_compiler = 'gcc' /a $txt_insert" ./SConstruct
  
  # case.3
  # adding -fuse-lld in LNKFLAGS
  txt_insert="if env['os'] == 'linux' and env['build'] == 'native' and 'clang++' in cpp_compiler and 'clang' in c_compiler:"
  echo $txt_insert >> ./SConstruct 
  txt_insert="    env.Append(LINKFLAGS = ['-fuse-lld'])"
  echo "$txt_insert" >> ./SConstruct 
else
  echo "setting ${CXX} as \$CXX"
  cd $ACL_ROOT_DIR/gcc/ComputeLibrary
fi

# Compile Arm Compute Library v20.11
# Note: 
#   clang++ v11.01 generates warning -Wdeprecated-copy. 
#   Please set Werror=0 or -Wno-deprecated-copy in SConstruct manually.
#
echo "start ACL build at ${PWD}"
date 
scons Werror=0 debug=0 asserts=0 arch=arm64-v8.2-a os=linux neon=1 opencl=1 examples=1 build=native pmu=1 benchmark_tests=1 -j4
echo "end ACL build at ${PWD}"
date
