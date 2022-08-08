#!/bin/sh

NAME="zlib"
VERSION="1.2.12"

TAR="$NAME-$VERSION.tar.gz"
SRCDIR="$NAME-$VERSION"

sl_download()
{
	sl_fetch_www "https://www.zlib.net/$TAR" "$TAR"
}

sl_extract()
{
	tar -xf "$TAR" && \
	ln -sf "$SRCDIR" "$NAME" && \
	return 0
	return 1
}

sl_build()
{
	case $MODE in
		"static")
			MODE_OPT="--static"
			;;
		"shared")
			MODE_OPT="--shared"
			;;
	esac
	cd "$SRCDIR" && \
	CFLAGS="$CFLAGS $ARCH" CC="$HOST-gcc" AR="$HOST-gcc-ar" sh configure $MODE_OPT --prefix="$INSTALL_DIR" --eprefix="$INSTALL_DIR" && \
	make clean && \
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
