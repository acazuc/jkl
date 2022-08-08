#!/bin/sh

NAME="freetype"
VERSION="2.12.0"

TAR="$NAME-$VERSION.tar.xz"
SRCDIR="freetype-$VERSION"

sl_download()
{
	sl_fetch_www "https://download.savannah.gnu.org/releases/freetype/$TAR" "$TAR"
}

sl_extract()
{
	tar -xf "$TAR"
	ln -sf "$SRCDIR" "$NAME"
}

sl_build()
{
	cd "$SRCDIR" && \
	sh configure --host "$HOST" CFLAGS="$CFLAGS $ARCH" CPPFLAGS="-I$INSTALL_DIR/include" LDFLAGS="-L$INSTALL_DIR/lib" --with-bzip2=no --with-harfbuzz=no --with-zlib=yes --with-png=yes --with-brotli=no --enable-static=$ENABLE_STATIC --enable-shared=$ENABLE_SHARED --prefix="$INSTALL_DIR" --exec-prefix="$INSTALL_DIR" && \
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
