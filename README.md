# odroidhc4-install
Ubuntu 20.04LTS installation on Aarch64 v8.2A Hardware(Hardkernel Odroid HC4) and some library setup.

## 1. Hardware preparation

YOU DON'T NEED SD Card/USB Memory TO BOOT! EXCELLENT!

- Hardkernel Odroid HC4 board https://www.hardkernel.com/shop/odroid-hc4/
- SATA 2.5inch SSD(maybe 256GByte or bigger)
- HDMI cable and Display
- AC/DC power adapter(choosing 15V/4A, but maybe ok for 2-3A)
- USB keyboard & mouse. Note only one USB3.0 port on HC4, USB hub is likely needed.
- Ether cable and public network connection.

![HC4](Odroid-HC4.jpg)

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
accountmngr@hc4armkk: sudo dpkg-reconfigure keyboard-configuration
accountmngr@hc4armkk: sudo sh -c "echo "hc4armkk" > /etc/hostname"
accountmngr@hc4armkk: sudo reboot
```

Then log-in again and let's run install_basic.sh script.
```
accountmngr@hc4armkk: mkdir -p ~/tmp && cd ~/tmp 
accountmngr@hc4armkk: git clone https://github.com/snakajim/odroidhc4-install
accountmngr@hc4armkk: cd odroidhc4-install/scripts 
accountmngr@hc4armkk: chmod +x * && sudo sh -c ./install_basic.sh
```

The script installs and sets basic environment for HC4.
- install gcc-7,8 and 10. Using gcc-8 as build tool.
- install basic apps used for build, such as cmake/java/pip3/ninja/aria2/z3, etc..
- avahi-daemon enabled, your hostname "hc4armkk" is accesable from local.
- at-daemon(atd) enabled.
- docker daemon enabled.
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
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.10.0-odroid-arm64 aarch64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Last login: xx xx xx xx:xx:xx 20xx from xxx.xxx.xxx.xxx
accountmngr@hc4armkk:~$
```

Copy public key under /home/user0/.ssh from your host consol(powershell/PuTTY/xterm/etc..).
```
$> scp <your_public_key> accountmngr@hc4armkk:/tmp
```

SSH login as accountmngr@hc4armkk and add the public key to authorized key list to user0. After setting the public key, reboot.
```
accountmngr@hc4armkk:~$ sudo sh -c "cp <your_public_key> /home/user0/.ssh/<your_public_key> && cat <your_public_key> >> /home/user0/.ssh/authorized_keys"
accountmngr@hc4armkk:~$ sudo chown -R user0:user0 /home/user0 
accountmngr@hc4armkk:~$ sudo reboot
```

To make easy access from your remote development environment such as Microsoft VS Code, Teraterm or PuTTY, it is nice idea to modify ssh configulation file which is usually stored in ${HOME}/.ssh/config
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

Now you are ready to ssh by short cut. 
```
$> ssh hc4armkk
(fingerprint check, etc... at first time)
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.10.0-odroid-arm64 aarch64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Last login: xx xx xx xx:xx:xx 20xx from xxx.xxx.xxx.xxx
user0@hc4armkk:~$
```

Or choose "Remote SSH: Connect Host..." in VS Code Pull Down Window and select "hc4armkk" from the list. There are several articles in web about Remote SSH in VS Code, so please refer them as well. 

Once you can successfully login as user0, let's run sample scripts under odroidhc4-install/scripts.
```
user0@hc4armkk:~$ cd ~/tmp && git clone https://github.com/snakajim/odroidhc4-install && cd ~/tmp/odroidhc4-install/scripts
user0@hc4armkk:~$ ls *.sh
install_acl.sh  install_basic.sh  install_compiler.sh  install_lld.sh install_llvm.sh install_polly.sh run run_user0.sh
```

To batch running scripts, use run_user0.sh with at command for example.
```
user0@hc4armkk:~$ cd ~/tmp/odroidhc4-install/scripts
user0@hc4armkk:~$ echo "./run_user0.sh > /dev/null 2>&1" | at now
```

### 4-a. Install Arm Compute Library on aarch64 linux

#### 4-a-1. building ACL

There is a build issue with default compiler gcc. You need to change to gcc-8 or clang-11.01. To utilzie v8.2A NEON feature, plese do not forget to set "arch=arm64-v8.2-a" and "neon=1" in scons args. Installation may take 5-6 hours.
```
user0@hc4armkk: cd odroidhc4-install/scripts && source ./install_acl.sh
```

Using clang may generate warning in compilation, ie -Wno-deprecated-copy. To avoid build error due to warning, please set "Werror=0" in scons args or -Wno-deprecated-copy in ComputeLibrary/SConstruct manually. You can see more about scons args in manual.

- https://arm-software.github.io/ComputeLibrary/v20.11/index.xhtml#S3_how_to_build

Compile time varies in which tool chain you choose. Here is a quick benchmark.

```
scons Werror=0 debug=0 asserts=0 arch=arm64-v8.2-a os=linux neon=1 opencl=1 examples=1 build=native pmu=1 benchmark_tests=1 -j4
```

The latest LLVM tools, both clang-11 and lld-11, does not help for HC4 native compile speed. 
And if you rush to compile, x86_64 cross compile is the way. 

|env     | tool chain                           | user time(min) | ratio |
|--------|--------------------------------------|----------------|-------|
|native  | gcc-8 + ld                           | 288            |1.00   |
|native  | clang-11 + lld-11                    | 377            |1.30   |
|native  | gcc-8 + lld-11                       | 288            |1.00   |
|cross(*)| aarch64-none-linux-gnu-g++-10.2      | 79             |0.27   |
|native-RPi4-4G Ubuntu20.04  | gcc-8 + ld       | 237            |0.82   |
|native-RPi4-4G Ubuntu20.04  | clang-11 + lld-11| 312            |1.08   |
    
(*) CentOS7 Docker container on Windows 10 Pro, assigning Core i5 v-CPUx4. You can access same version of cross compiler from here.
- https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz

#### 4-a-2. running tests given in ACL

- https://arm-software.github.io/ComputeLibrary/v20.11/tests.xhtml#tests_running_tests

To check the list of test vectors, 
```
user0@hc4armkk:~$ cd ComputeLibrary/build/test && \
export LD_LIBRARY_PATH=${PWD}/..:$LD_LIBRARY_PATH && \
./arm_compute_benchmark --help
```


### 4-b. Install LLVM1101(clang/clang++/libcxx/libcxxabi/lld/openmp) on aarch64 linux

There is a build issue with default compiler gcc. You need to change to gcc-8 or clang-11.01. LLVM build may take 5 hours. After install llvm, recommend to reboot.

```
user0@hc4armkk:~$ cd odroidhc4-install/scripts && source ./install_llvm.sh
```

Or if you need lld-11 only, 
```
user0@hc4armkk:~$ cd odroidhc4-install/scripts && source ./install_lld.sh
```


To enable clang/lld after install, set env params. Note "lld" is sometimes installed as "ld.lld" in Linux. 
```
user0@hc4armkk:~$ export LLVM_DIR=/usr/local/llvm_1101
user0@hc4armkk:~$ export PATH=$LLVM_DIR/bin:$PATH
user0@hc4armkk:~$ export LIBRARY_PATH=$LLVM_DIR/lib:$LIBRARY_PATH
user0@hc4armkk:~$ export LD_LIBRARY_PATH=$LLVM_DIR/lib:$LD_LIBRARY_PATH
user0@hc4armkk:~$ which lld  && lld --version
/usr/local/llvm_1101/bin/lld
lld is a generic driver.
user0@hc4armkk:~$ which ld && ld --version
/usr/bin/ld
GNU ld (GNU Binutils for Ubuntu) 2.34
```

For details about lld, see manual page. 
- https://lld.llvm.org/

#### 4-b-1. LLVM polly

Polly is a LLVM Framework for High-Level Loop and Data-Locality Optimizations. You can enable polly just parsing "-O3 -mllvm -polly" options. 

```
clang -O3 -mllvm -polly file.c
```

Runtime benchmark result To Be Measured.

### 4-c. Install arm baremetal compiler on aarch64 linux

Using "GNU Arm Embedded Toolchain Version 10-2020-q4-major" as example. You can check the latest version from here. 
- https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads

```
user0@hc4armkk:~$ cd odroidhc4-install/scripts && source ./install_compiler.sh
```


## 5. Aarch64 v8.2A optimiztion tips

Coming later...

## 6. Docker private repository on Odroid HC4

The goal is to utilize Odroid HC4 board as docker private repository server in local network. 

### 6-a. Docker Enging installation on Aarch64 Ubuntu.20.04

Install the latest docker-ce on Ubuntu.20.04, detailed instruction is in docker docs.

- https://docs.docker.com/engine/install/ubuntu/

Or Ubuntu-20.04 has already prepared docker in repo, so use it.

```
user0@hc4armkk:~$ sudo apt-get install -y docker.io
user0@hc4armkk:~$ sudo gpasswd -a $USER docker
user0@hc4armkk:~$ sudo chmod 666 /var/run/docker.sock
```

Assume your install is done, make sure that docker.service daemon is hot and you can run hello-world without sudo permission.

```
user0@hc4armkk:~$  sudo systemctl status docker.service
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; disabled; vendor preset: enabled)
     Active: active (running)
     ....
user0@hc4armkk:~$ docker run hello-world
```

### 6-b. Start docker private registroy service  
Docker private registry service is using docker registry contaier provided by docker.

- https://hub.docker.com/_/registry/

Coming soon...

### 6-c. Testing to push/pull
Coming soon...

## Appendix Revision history
- v1.1: update for stability and multi-platform support(Win10 docker and RPi4 native), 2020-Jan-30
- v1.0: initial version, 2021-Jan-19
