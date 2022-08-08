#!/bin/sh

NAME="openssl"
VERSION="1.1.1n"

TAR="$NAME-$VERSION.tar.gz"
SRCDIR="$NAME-$VERSION"

sl_download()
{
	sl_fetch_www "https://www.openssl.org/source/$TAR" "$TAR"
}

sl_extract()
{
	tar -xf "$TAR"
	ln -sf "$SRCDIR" "$NAME"
}

sl_build()
{
	case $TARGET in
		"linux_32")
			CONFIG="linux-x86"
			;;
		"linux_64")
			CONFIG="linux-x86_64"
			;;
		"windows_32")
			CONFIG="mingw"
			;;
		"windows_64")
			CONFIG="mingw64"
			;;
		"host")
			CONFIG="linux-x86_64"
			;;
	esac
	case $MODE in
		"static")
			NO_SHARED="no-shared"
			;;
		"shared")
			NO_SHARED=""
			;;
	esac
	cd "$SRCDIR" && \
	perl Configure $NO_SHARED $CONFIG $CFLAGS $ARCH --cross-compile-prefix=$HOST- --prefix="$INSTALL_DIR" && \
	make clean && \
	make build_generated && \
	make -j "$JOBS" && \
	make install -j "$JOBS" && \
	return 0
	return 1
}

sl_cleanup()
{
	rm -rf "$SRCDIR"
}

. ../mk.sh
