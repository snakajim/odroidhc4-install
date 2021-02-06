#!/bin/bash
#
# batch for install_xx.sh
# 
# How to run:
# $> source ./run_user0.sh
# To use at command:
# $> echo "./run_user0.sh > /dev/null 2>&1" | at now
#
run_dir=${PWD}

# ACL with gcc
#/usr/bin/time -ao out.log echo "ahoge" >& out.log

export CXX="/usr/bin/g++-8"
export CC="/usr/bin/gcc-8"

./install_acl.sh >& ./install_acl.gcc.log

# install LLVM1101
cd $run_dir
./install_llvm.sh >& ./install_llvm.log 
#source ${HOME}/.bashrc
#exec $SHELL -l

# ACL with LLVM
cd $run_dir
unset CXX
unset CC
./install_acl.sh >& ./install_acl.llvm.log
sudo reboot

