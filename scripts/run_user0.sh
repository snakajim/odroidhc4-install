#!/bin/bash
#
# batch for install_xx.sh
# 
# How to run:
# $> source ./run_user0.sh
# To use at command:
# $> echo "./run_user0.sh > /dev/null 2>&1" | at now
#
# ACL with gcc
#/usr/bin/time -ao out.log echo "ahoge" >& out.log
export CXX="/usr/bin/g++-7"
export CC="/usr/bin/gcc-7"
/usr/bin/time -ao ./install_acl.gcc.log ./install_acl.sh >& ./install_acl.gcc.log

# install LLVM1101
/usr/bin/time -ao ./install_llvm.log ./install_llvm.sh >& ./install_llvm.log 
exec $SHELL -l

# ACL with LLVM
unset CXX
unset CC
/usr/bin/time -ao ./install_acl.llvm.log ./install_acl.sh >& ./install_acl.llvm.log