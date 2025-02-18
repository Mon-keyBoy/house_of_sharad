#!/bin/sh

# might need to sleep more depending on how many resources (how slow the box is) the box has
sleep 10
/sbin/kldstat | grep -q "LD_PRELOAD.ko" || /sbin/kldload /boot/modules/LD_PRELOAD.ko
