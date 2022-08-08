#!/bin/sh

NAME="jks"

SRCDIR="jks"

sl_download()
{
	return 0
}

sl_extract()
{
	return 0
}

sl_build()
{
	cd "$SRCDIR" && \
	sh autogen.sh && \
	sh configure CFLAGS="$CFLAGS $ARCH" --host="$HOST" --enable-static="$ENABLE_STATIC" --enable-shared="$ENABLE_SHARED" --prefix="$INSTALL_DIR" --exec-prefix="$INSTALL_DIR" && \
	make clean && \
	make -j "$JOBS" && \
	make install -j "$JOBS" && \
	return 0
	return 1
}

sl_cleanup()
{
	return 0
}

. ../mk.sh
