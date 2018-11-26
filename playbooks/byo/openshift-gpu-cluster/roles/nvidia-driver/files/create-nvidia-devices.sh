#!/bin/bash

set -x

cd /sys/bus/pci/devices

VENDOR_ID=0x10de

NUM_OF_DISP_DEV=`cat */vendor | grep ${VENDOR_ID} | wc -l`

N=`expr ${NUM_OF_DISP_DEV} - 1`

for i in `seq 0 ${N}`
do
	if [ ! -e /dev/nvidia${i} ]; then
		mknod -m 666 /dev/nvidia${i} c 195 ${i}
	fi
done

if [ ! -e /dev/nvidiactl ]; then
	mknod -m 666 /dev/nvidiactl      c 195 255
fi

if [ ! -e /dev/nvidia-modeset ]; then
	mknod -m 666 /dev/nvidia-modeset c 195 254
fi


D=`grep nvidia-uvm /proc/devices | awk '{print $1}'`

if [ ! -e /dev/nvidia-uvm ]; then
	mknod -m 666 /dev/nvidia-uvm       c $D 0
fi 

if [ ! -e /dev/nvidia-uvm-tools ]; then
	mknod -m 666 /dev/nvidia-uvm-tools c $D 1
fi
