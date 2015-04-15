#!/usr/bin/env bash

# This is a simple script that will check the physical memory,
# then build a swapfile with the correct size. If the physical
# mem is less then 8 gig, a swapfile will be created that matches
# the size of physical memory. If pysical memory is more then 8 gig
# the swap will be set to 1/2 the size of physical memory.

PHYS_MEM=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')
SWAP_MEM=$(($PHYS_MEM/1024/1024))
if [[ $SWAP_MEM -gt 8 ]]
  then
    SWAP_MEM=$(($SWAP_MEM/2))
fi

mkdir /swap
dd if=/dev/zero of=/swap/swapfile.img bs=1024 count=${SWAP_MEM}M
mkswap /swap/swapfile.img
echo "/swap/swapfile.img swap swap sw 0 0" > /etc/fstab
swapon /swap/swapfile.img
