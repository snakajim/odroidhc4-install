#
# install_uvc.sh
#
# Connect USB camera(UVC) and display simple images on X windows.
#   Before you start this script, you need to enable X11 window manager on your host. 
#   Recommending to use Mobaxterm if your host is windows10,
#   and set windows managers IP address in your guest $DISPLAY
#   $> export DISPLAY=192.168.2.101:0.0
#
# This script has been tested on
#   - KHADAS VIM3 Pro Debian server 5.9 rc2 

## 
# 1. check you have USB cam. This script is tested with "Logitech, Inc. Webcam C270"
##
lsusb | grep "Webcam C270"
ret=$?
if [ $ret -eq 0 ]; then
  echo "Webcam is detected. Resolution list is,"
  cameraid=`lsusb | grep "Webcam C270" | awk -F ":" '{print $1}' | awk '{print $2 ":" $4}'`
  lsusb -s ${cameraid} -v | grep -1 Width
  sleep 1
else
  echo "Webcam is not delected. Please confirm USB camera connectivity."
  exit
fi

##
# 2. Install viewers 
##
sudo apt-get install -y guvcview uvccapture fswebcam
sudo sh -c "gpasswd -a user0 video"
#
