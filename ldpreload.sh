#!/bin/sh

sleep 30
kldstat | grep -q "LD_PRELOAD.ko" || /sbin/kldload /boot/modules/LD_PRELOAD.ko

