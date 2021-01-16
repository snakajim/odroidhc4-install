# odroidhc4-install
Hardkernel Odroid HC4 install &amp; Setup support

## hardware manual and preparation

- Hardkernel Odroid HC4 https://www.hardkernel.com/shop/odroid-hc4/
- SATA IF 2.5 SSD(maybe 256GByte or bigger)
- HDMI cable
- AC/DC power adapter
- USB keyboard & mouse. Note only one USB3.0 port on HC4 so USB hub is likely needed.
- Ether cable and public network connection.

## Petiboot netboot

After power on, no netboot list is available. So you need to find netboot-able images from network using petiboot loader. This is done by the following command.
```
Choose  "Exit to shell" and ENTER
(in console)
# netboot_default
# exit
```

Then you have net install list above. In this example I'm using Ubuntu 20.04. 
Assume you select appropriate setting in install procedure, then reboot.

## 
