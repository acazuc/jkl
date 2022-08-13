#!/bin/sh

NAME="harfbuzz"
VERSION="4.4.1"

TAR="$NAME-$VERSION.tar.xz"
SRCDIR="harfbuzz-$VERSION"

sl_download()
{
	sl_fetch_www "https://github.com/harfbuzz/harfbuzz/releases/download/$VERSION/$TAR" "$TAR"
}

sl_extract()
{
	tar -xf "$TAR"
	ln -sf "$SRCDIR" "$NAME"
}

sl_build()
{
	cd "$SRCDIR" && \
	sh configure --host "$HOST" CFLAGS="$CFLAGS $ARCH" CPPFLAGS="-I$INSTALL_DIR/include" LDFLAGS="-L$INSTALL_DIR/lib" --with-gobject=no --with-cairo=no --with-chafa=no --with-icu=no --with-graphite2=no --with-freetype=no --enable-static=$ENABLE_STATIC --enable-shared=$ENABLE_SHARED --prefix="$INSTALL_DIR" --exec-prefix="$INSTALL_DIR" && \
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
