# odroidhc4-install
Ubuntu 20.04LTS installation on Aarch64 v8.2A Hardware(Hardkernel Odroid HC4) and some ubuntu setup.

## 1.hardware manual and preparation

- Hardkernel Odroid HC4 https://www.hardkernel.com/shop/odroid-hc4/
- SATA IF 2.5 SSD(maybe 256GByte or bigger)
- HDMI cable
- AC/DC power adapter
- USB keyboard & mouse. Note only one USB3.0 port on HC4 so USB hub is likely needed.
- Ether cable and public network connection.

## 2.Petiboot netboot and Ubuntu install

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

| item     | setting |
-----------|---------|
| rootID   | accountmngr |
| rootpwd  | <as_u_like> |
| hostname | hc4armkk |


## Install applications as root
Login in as accountmngr with password you set during Ubuntu installation. First thing you need to do is,

```
$> sudo apt-get update -y
$> sudo apt-get install -y  build-essential  
```

Then let's run install script.
```
$> mkdir -p ~/tmp && cd ~/tmp 
$> git clone https://github.com/snakajim/odroidhc4-install
$> cd odroidhc4-install/scripts 
$> sudo source ./install_basic.sh
```
## ssh login as user0, and install optional applications

Please copy public key under /home/user0/.ssh by somehow, and set it as authorized key.
```
user0@hc4armkk: cd /home/user0/.ssh && cat <your_public_key> >> authorized_keys
```

In your remote environment, add ssh configulation. Your ssh config file is usually in ${HOME}/.ssh/config
```
Host hc4armkk
    HostName hc4armkk
    User user0
    Port 22
    IdentityFile ~/.ssh/<your_key_pair_name>
    ServerAliveInterval 120
    ServerAliveCountMax 60
    ForwardX11 yes
```

After establishing ssh connection, you can install optional apps with scripts.

```
user0@hc4armkk: cd ~/tmp && git clone https://github.com/snakajim/odroidhc4-install && cd ~/tmp/odroidhc4-install/scripts
```

