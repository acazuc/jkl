#!/bin/sh

NAME="libvorbis"
VERSION="1.3.7"

TAR="$NAME-$VERSION.tar.xz"
SRCDIR="$NAME-$VERSION"

sl_download()
{
	sl_fetch_www "https://downloads.xiph.org/releases/vorbis/$TAR" "$TAR"
}

sl_extract()
{
	tar -xf "$TAR"
	ln -sf "$SRCDIR" "$NAME"
}

sl_build()
{
	cd "$SRCDIR" && \
	sh configure CFLAGS="$CFLAGS $ARCH" CPPFLAGS="-I$INSTALL_DIR/include" LDFLAGS="-L$INSTALL_DIR/lib"  --host="$HOST" --enable-static="$ENABLE_STATIC" --enable-shared="$ENABLE_SHARED" --prefix="$INSTALL_DIR" --exec-prefix="$INSTALL_DIR" && \
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
