# mcwm - minimal custom window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c mcwm.c util.c
OBJ = ${SRC:.c=.o}

all: mcwm

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

mcwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f mcwm ${OBJ} mcwm-${VERSION}.tar.gz

dist: clean
	mkdir -p mcwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		mcwm.1 drw.h util.h ${SRC} mcwm.png transient.c mcwm-${VERSION}
	tar -cf mcwm-${VERSION}.tar mcwm-${VERSION}
	gzip mcwm-${VERSION}.tar
	rm -rf mcwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f mcwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/mcwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < mcwm.1 > ${DESTDIR}${MANPREFIX}/man1/mcwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/mcwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/mcwm\
		${DESTDIR}${MANPREFIX}/man1/mcwm.1

.PHONY: all clean dist install uninstall

