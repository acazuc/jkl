#!/bin/sh

NAME="libxml2"
VERSION="2.9.9"

TAR="$NAME-v$VERSION.tar.gz"
SRCDIR="$NAME-v$VERSION"

sl_download()
{
	sl_fetch_www "https://gitlab.gnome.org/GNOME/libxml2/-/archive/v$VERSION/$TAR" "$TAR"
}

sl_extract()
{
	tar -xf "$TAR"
	ln -sf "$SRCDIR" "$NAME"
}

sl_build()
{
	cd "$SRCDIR" && \
	sh autogen.sh && \
	sh configure --host "$HOST" CFLAGS="$CFLAGS $ARCH" --enable-static="$ENABLE_STATIC" --enable-shared="$ENABLE_SHARED" --without-debug --without-docbook --without-ftp --without-http --without-iconv --without-python --without-zlib --without-lzma --prefix="$INSTALL_DIR" --exec-prefix="$INSTALL_DIR" && \
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
