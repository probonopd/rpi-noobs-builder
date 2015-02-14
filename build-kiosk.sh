#!/bin/bash

# See
# https://github.com/raspberrypi/noobs/wiki/NOOBS-partitioning-explained
# for the boot process. Root password is "raspberry" as we see in buildroot/.config

wget http://downloads.raspberrypi.org/NOOBS_lite_latest -O NOOBS_lite_latest.zip
unzip NOOBS_lite_latest.zip

# "Install" lzop
mkdir local
cd local
wget http://mirrors.kernel.org/ubuntu/pool/universe/l/lzop/lzop_1.02~rc1-2_amd64.deb
ar x *.deb
tar xfz data.tar.gz
rm *.tar.gz *.deb debian-binary
cd -
export PATH=$PWD/local/usr/bin:$PATH

# Extract rootfs
mkdir rootfs
cd rootfs
cat ../recovery.rfs | lzop -d | sudo cpio -idv # Needs root here

# Make changes
# /usr/bin/arora -qws 2>/tmp/debug-qws

# Package rootfs
sudo chown -R root:root .
find . | cpio -o -H newc | lzop -9 > ../recovery.rfs
