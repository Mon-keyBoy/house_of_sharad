CFLAGS+= -fno-stack-protector -fno-stack-check
KMOD= apekit_rootshit
SRCS= rev_shells.c
CC= clang15
LD?= /usr/local/bin/ld.lld15

.include <bsd.kmod.mk>
