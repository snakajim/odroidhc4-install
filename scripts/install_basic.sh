#!/bin/bash
# to windows/linux comaptibility

#
# install several tools by apt-get
#
sudo apt-get install 
#
# install or upgrage tools from source
#
#
TMPDIR=${HOME}/tmp
if [ ! -d $TMPDIR ]; then
    mkdir -p $TMPDIR
fi

# install git 
cd $TMPDIR

# install cmake

# install and enable avahi-daemon
