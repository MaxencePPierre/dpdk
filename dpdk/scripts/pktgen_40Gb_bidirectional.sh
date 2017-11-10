#!/bin/bash

mount -t hugetlbfs nodev /mnt/huge
mount -t hugetlbfs nodev /mnt/huge_2mb -o pagesize=2mb
mount

#Do not forget to change the path to DPDK directory
export DPDK_DIR=/home/maintain/Documents/dpdk-stable-16.07.2

modprobe uio
insmod $DPDK_DIR/x86_64-native-linuxapp-gcc/kmod/igb_uio.ko
#You need to know the PCI bus of your 40Gb ethernet controller (in my case it was 0000:02:00.0), run "lscpi | greth Eth""
$DPDK_DIR/tools/dpdk-devbind.py -b igb_uio 0000:02:00.0
$DPDK_DIR/tools/dpdk-devbind.py -b igb_uio 0000:02:00.0


#Do not forget to change the path to Pktgen directory
export PKTGEN_DIR=/home/maintain/Documents/pktgen-3.4.0
cd $PKTGEN_DIR

./app/app/x86_64-native-linuxapp-gcc/pktgen -l 0-3 -n 4 -- -T -P -m "[1-3].0, [4-6].1" -f themes/white-black.theme
