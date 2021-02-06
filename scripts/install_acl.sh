#!/bin/bash
#
# install Arm Computing Library on Aarch64 Ubuntu20.04.
# How to use:
# $> \time -ao install_acl.log ./install_acl.sh >& install_acl.log &
#
ARCH=`arch`
source ${HOME}/.bashrc

# Downlaod and install
#
ACL_ROOT_DIR=${HOME}/work

# Get Force scon using clang or gcc-8. 
#
if [ $ARCH = "x86_64" ]; then
  echo "Cross compile on x86_64 linux system."
  unset CC
  unset CXX
  isDefault=1
else 
  if [ -n "$CXX" ] && [ -n "$CC" ]; then
    echo "Default compiler setting is found in system."
    echo "Use the Default setting for compile. cpp=$CXX and cc=$CC."
    isDefault=1
  else
    echo "Default compiler is not set, cpp=$CXX, cc=$CC" 
    export CXX="/usr/bin/g++-8"
    export CC="/usr/bin/gcc-8"
    echo "Forcing compiler to cpp=$CXX and cc=$CC."
    isDefault=0
  fi
fi

if [ ! -d $ACL_ROOT_DIR/gcc/ComputeLibrary ]; then
  mkdir -p $ACL_ROOT_DIR/gcc
  cd $ACL_ROOT_DIR/gcc
  if [ ! -d $ACL_ROOT_DIR/gcc/ComputeLibrary ]; then
    git clone https://github.com/ARM-software/ComputeLibrary.git -b v20.11
  fi
fi

if [ ! -d $ACL_ROOT_DIR/llvm ]; then
  mkdir -p $ACL_ROOT_DIR/llvm
fi

which clang
ret=$?
if [ $ret -eq 0 ] && [ $isDefault -eq "0" ]; then
  echo "LLVM-clang is found in your system, switching to clang as building tool."
  export CXX=`which clang++`
  export CC=`which clang`
  echo "setting ${CXX} as \$CXX"
  cd $ACL_ROOT_DIR/llvm
  if [ ! -d $ACL_ROOT_DIR/llvm/ComputeLibrary ]; then
    git clone https://github.com/ARM-software/ComputeLibrary.git -b v20.11
  fi
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

  # case.4
  # replace -std=gnu++11 to -stdlib=libc++
  sed -e 's/-std=gnu++11/-stdlib=libc++/' -i ./SConstruct

else
  echo "setting ${CXX} as \$CXX"
  cd $ACL_ROOT_DIR/gcc/ComputeLibrary
fi

# case.4 
# To enable dptprod, replacing 
# elif 'v8.2-a' in env['arch']:
#      env.Append(CXXFLAGS = ['-march=armv8.2-a+fp16'])
# to
#elif 'v8.2-a' in env['arch']:
#      env.Append(CXXFLAGS = ['-march=armv8.2-a+fp16+dotprod'])
perl -pe "s/armv8\.2-a\+fp16'/armv8\.2-a\+fp16\+dotprod'/g" -i ./SConstruct

# Compile Arm Compute Library v20.11
# Note: 
#   clang++ v11.01 generates warning -Wdeprecated-copy. 
#   Please set Werror=0 or -Wno-deprecated-copy in SConstruct manually.
#
echo "start ACL build at ${PWD}"
date
if [ $ARCH = "x86_64" ]; then 
  /usr/bin/time -av sh -c \
    "scons Werror=0 debug=0 asserts=0 arch=arm64-v8.2-a os=linux neon=1 opencl=1 examples=1 pmu=1 benchmark_tests=1 -j4"
  echo "end ACL build at ${PWD}"
else
  /usr/bin/time -av sh -c \
    "scons Werror=0 debug=0 asserts=0 arch=arm64-v8.2-a os=linux neon=1 opencl=1 examples=1 build=native pmu=1 benchmark_tests=1 -j4"
  echo "end ACL build at ${PWD}"
fi
date
