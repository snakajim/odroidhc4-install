# odroidhc4-install
Ubuntu 20.04LTS installation on Aarch64 v8.2A Hardware(Hardkernel Odroid HC4) and some ubuntu setup.

## hardware manual and preparation

- Hardkernel Odroid HC4 https://www.hardkernel.com/shop/odroid-hc4/
- SATA IF 2.5 SSD(maybe 256GByte or bigger)
- HDMI cable
- AC/DC power adapter
- USB keyboard & mouse. Note only one USB3.0 port on HC4 so USB hub is likely needed.
- Ether cable and public network connection.

## Petiboot netboot and Ubuntu install

After power on, no netboot list is available. So you need to find netboot-able images from network using petiboot loader. This is done by the following command.
```
Choose  "Exit to shell" at the bottom of petiboot menu then Press-ENTER
(switch to console then)
# netboot_default
# exit
(back to petiboot menu)
```

Now you should have net install-able image list if your ether cable is correctly connected to network. In this example I'm choosing Ubuntu 20.04LTS. 
Assume you select appropriate setting in install procedure. Total OS installation may take 1.0 hour. After installation, reboot system and start Ubuntu CLI.

## Install applications, etc..
Login in your username and password you sed during Ubuntu installation. First thing you need to do is,

```
$> sudo apt-get update -y
$> sudo apt-get install -y  build-essential  
```

Then let's use simplified install script.
```
$> mkdir -p ~/tmp && cd ~/tmp 
$> git clone https://github.com/snakajim/odroidhc4-install
$> cd odroidhc4-install/scripts 
$> sudo source ./xxx.sh
```
