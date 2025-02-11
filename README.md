The "unused" directory holds the c code that compiles binaries.

To compile "apeshit" within pfsense you need to use "clang15 -I/sys -o apeshit apeshit_daemon.c" since stdio.h doesn't k know the path of cdefs.h. 

"apeshit_damon.c" produces "apeshit" which is a binary that creates a daemon that sleeps infinitly and is named apeshit, you can see it with "pgrep -l apeshit".
