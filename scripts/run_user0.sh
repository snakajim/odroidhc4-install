#!/bin/bash
#
# batch for install_xx.sh
# 
# How to run:
# $> source ./run_user0.sh
#

# ACL with gcc
#\time -ao out.log echo "ahoge" >& out.log
unset CC
unset CXX
\time -ao ./install_acl.gcc.log ./install_acl.sh >& ./install_acl.gcc.log

# install LLVM1101
\time -ao ./install_llvm.log ./install_llvm.sh >& ./install_llvm.log 
exec $SHELL -l

# ACL with LLVM
\time -ao ./install_acl.llvm.log ./install_acl.sh >& ./install_acl.llvm.log 
 