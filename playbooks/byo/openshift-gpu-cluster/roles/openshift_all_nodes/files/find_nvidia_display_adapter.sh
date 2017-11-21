#!/bin/bash

set -x
set -e

cd /sys/bus/pci/devices

VENDOR_ID=$1

for i in `ls /sys/bus/pci/devices`
do
    VENDOR=`cat $i/vendor`
    CLASS=`cat $i/class`

    if [ $(( ${VENDOR} ^ ${VENDOR_ID} )) == 0 ]; then
        echo "Found NVIDIA PCI card"
        # 0x300=VGA 0x302=3D
        CLASS_DISPLAY=$(( ${CLASS} & 0xff0000 ))
        if [ $(( ${CLASS_DISPLAY} ^ 0x030000 )) == 0 ]; then
            echo "Found NVIDIA PCI display adapter"
            exit 0
        fi

    fi
done

exit 1


#crw-rw-rw-. 1 root root 195,   0 Nov 20 10:20 /dev/nvidia0
#crw-rw-rw-. 1 root root 195, 255 Nov 20 10:20 /dev/nvidiactl
#crw-rw-rw-. 1 root root 245,   0 Nov 20 10:50 /dev/nvidia-uvm
#crw-rw-rw-. 1 root root 245,   1 Nov 20 10:50 /dev/nvidia-uvm-tools
