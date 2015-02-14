#!/bin/bash

# See
# https://github.com/raspberrypi/noobs/wiki/NOOBS-partitioning-explained
# for the boot process. Root password is "raspberry" as we see in buildroot/.config

#
# This script needs root rights because otherwise the permissions inside
# the recovery.rfs become messed up
#

wget http://downloads.raspberrypi.org/NOOBS_lite_latest -O NOOBS_lite_latest.zip
unzip NOOBS_lite_latest.zip

# "Install" lzop
sudo apt-get install lzop

# Extract rootfs
mkdir rootfs
cd rootfs
cat ../recovery.rfs | lzop -d | sudo cpio -idv # Needs root here

# Make changes
# /usr/bin/arora -qws 2>/tmp/debug-qws
sed -i -e 's|recovery $RUN_INSTALLER $GPIO_TRIGGER $KEYBOARD_NO_TRIGGER $FORCE_TRIGGER $DEFAULT_KBD $DEFAULT_LANG $DEFAULT_DISPLAY $DEFAULT_PARTITION|arora|g' init

# Package rootfs
sudo find . | sudo cpio -o -H newc | lzop -9 > ../recovery.rfs
