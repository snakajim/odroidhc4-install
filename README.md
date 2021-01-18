# odroidhc4-install
Ubuntu 20.04LTS installation on Aarch64 v8.2A Hardware(Hardkernel Odroid HC4) and some library setup.

## 1. Hardware preparation

YOU DON'T NEED SD Card/USB Memory TO BOOT! EXCELLENT!

- Hardkernel Odroid HC4 https://www.hardkernel.com/shop/odroid-hc4/
- SATA IF 2.5 SSD(maybe 256GByte or bigger)
- HDMI cable
- AC/DC power adapter
- USB keyboard & mouse. Note only one USB3.0 port on HC4, so USB hub is likely needed.
- Ether cable and public network connection.

## 2. Petiboot netboot and Ubuntu install

After power on, no netboot list is available in pepiboot menu. So you need to find netboot-able images from network using petiboot loader. This is done by the following command.
```
Choose  "Exit to shell"
(switch to console then)
# netboot_default
# exit
(back to petiboot menu)
```

Now you can see "net install-able" image list if your ether cable is correctly connected to network. In this example I'm choosing Ubuntu 20.04LTS. 
Assume you select appropriate setting in install procedure. 

| item     | setting |
|----------|---------|
| account  | accountmngr |
| pwd      | <as_u_like> |
| hostname | hc4armkk |

Total OS installation may take 1.0 hour. After installation, reboot system and start Ubuntu CLI.

## 3. Install applications & libs as root
Login in as accountmngr with password you set during Ubuntu installation. First thing you need to do is,

```
accountmngr@hc4armkk: sudo apt-get update -y
accountmngr@hc4armkk: sudo apt-get install -y  build-essential git
```

Then let's run basic install script.
```
accountmngr@hc4armkk: mkdir -p ~/tmp && cd ~/tmp 
accountmngr@hc4armkk: git clone https://github.com/snakajim/odroidhc4-install
accountmngr@hc4armkk: cd odroidhc4-install/scripts 
accountmngr@hc4armkk: chmod +x * && sudo sh -c ./install_basic.sh
```

The script installs and sets basic environment for HC4.
- install gcc-7,8 and 10. Default tool chain is gcc-9.
- install basic apps.
- avahi-daemon enabled, your hostname hc4armkk is accesable from local.
- user account "user0" is created with sudo authority. 

Some application does not recommend to install as root, so let's switch login account to "user0" and continue.

## 4. Install optional applications & libs as non-root user

HC4 hardware is broadcasting its hostname by mDNS avahi-daemon, so that you can reach the hardware just by hostname. To confirm mDNS is surely working, ping to HC4. 
```
$> ping hc4armkk
hc4armkk.local [fe80::35e:6cf:fe79:ce%3]に ping を送信しています 32 バイトのデータ:
fe80::35e:6cf:fe79:ce%3 からの応答: 時間 =3ms
fe80::35e:6cf:fe79:ce%3 からの応答: 時間 <1ms
fe80::35e:6cf:fe79:ce%3 からの応答: 時間 <1ms
fe80::35e:6cf:fe79:ce%3 からの応答: 時間 <1ms

fe80::35e:6cf:fe79:ce%3 の ping 統計:
    パケット数: 送信 = 4、受信 = 4、損失 = 0 (0% の損失)、
ラウンド トリップの概算時間 (ミリ秒):
    最小 = 0ms、最大 = 3ms、平均 = 0ms
```

To start with setting user0 profile, ssh connect to hc4armkk as root(accountmngr).
```
$> ssh accountmngr@hc4armkk
password: <as_u_like>
```

Copy public key under /home/user0/.ssh by somehow and set it as authorized key to user0. After setting the public key, reboot.
```
accountmngr@hc4armkk: sudo sh -c "cp <your_public_key> /home/user0/.ssh/<your_public_key> && cat <your_public_key> >> /home/user0/.ssh/authorized_keys"
accountmngr@hc4armkk: sudo chown -R user0:user0 /home/user0 
accountmngr@hc4armkk: reboot
```

In your remote development environment such as Microsoft VS Code, add ssh configulation file which is usually in ${HOME}/.ssh/config
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

Now you are ready to connect from remote. Just choose "Remote SSH: Connect Host..." in VS Code Pull Down Window and select "hc4armkk" from the list. There are several articles in web about Remote SSH in VS Code, so please refer them as well. 

Once you can successfully login as user0, let's test sample scripts under odroidhc4-install/scripts.

```
user0@hc4armkk: cd ~/tmp && git clone https://github.com/snakajim/odroidhc4-install && cd ~/tmp/odroidhc4-install/scripts
user0@hc4armkk: ls *.sh
install_acl.sh  install_basic.sh  install_compiler.sh  install_llvm.sh
```

### a. Install Arm Compute Library on aarch64 linux
There is build issue with default compiler gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0. You need to change gcc-7 or clang-11.01. To utilzie v8.2A NEON feature, plese do not forget to set "arch=arm64-v8.2-a" and "neon=1" in scons args. Installation may take 5-6 hours.
```
user0@hc4armkk: cd odroidhc4-install/scripts && source ./install_acl.sh
```

Using clang may generate warning in compilation, ie -Wno-deprecated-copy. To avoid build error due to warning, please set "Werror=0" in scons args or -Wno-deprecated-copy in ComputeLibrary/SConstruct manually. You can see more about scons args in manual.

- https://arm-software.github.io/ComputeLibrary/v20.11/index.xhtml#S3_how_to_build

Compile time varies in which tool chain you choose. Here is a quick benchmark.

```
scons Werror=0 debug=0 asserts=0 arch=arm64-v8.2-a os=linux neon=1 opencl=1 examples=1 build=native pmu=1 benchmark_tests=1 -j4
```

| tool chain     | ACL compile time(min) | ratio |
|----------------|-----------------------|-------|
| gcc-7 + ld     | <TBM>                 |<TBM>  |
| clang-11 + lld-11 | <TBM>              |<TBM>  |
| gcc-7 + lld-11 | <TBM>                 |<TBM>  |
    


### b. Install LLVM1101(clang/clang++/libcxx/libcxxabi/lld/openmp) on aarch64 linux
There is build issue with default compiler gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0. You need to change gcc-7 to build. Installation may take 5-6 hours. After install llvm, recommend to reboot.

```
user0@hc4armkk: cd odroidhc4-install/scripts && source ./install_llvm.sh
```

To enable clang/lld after install, set env params. Note "lld" is install as "ld.lld" in Linux. 
```
user0@hc4armkk: export LLVM_DIR=/usr/local/llvm_1101
user0@hc4armkk: export PATH=$LLVM_DIR/bin:$PATH
user0@hc4armkk: export LIBRARY_PATH=/usr/lib/llvm-10/lib:$LIBRARY_PATH
user0@hc4armkk: which lld  && lld --version
/usr/local/llvm_1101/bin/lld
lld is a generic driver.
user0@hc4armkk: which ld && ld --version
/usr/bin/ld
GNU ld (GNU Binutils for Ubuntu) 2.34
```

You can simply link "ld.lld" as standard "ld" under /usr/bin, or parse "-fuse-ld=lld" at link time.

For details about lld, see manual page. 
- https://lld.llvm.org/

### c. Install arm baremetal compiler on aarch64 linux
Using "GNU Arm Embedded Toolchain Version 10-2020-q4-major" as example. You can check the latest version from here. 
- https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads

```
user0@hc4armkk: cd odroidhc4-install/scripts && source ./install_compiler.sh
```


## 5. Aarch64 v8.2A optimiztion tips
Coming later...

## Revision history
v1.0: initial version, 2021-Jan
