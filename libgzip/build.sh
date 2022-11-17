#!/bin/sh

NAME="libgzip"

SRCDIR="$NAME"

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
	make clean && \
	make CXX="$HOST-g++" CXXFLAGS="$ARCH $CFLAGS" AR="$HOST-ar" RANLIB="$HOST-ranlib" -j "$JOBS" INCLUDES="-I $INSTALL_DIR/include" && \
	mkdir -p "$INSTALL_DIR/include/libgzip" && \
	cp -R src/* "$INSTALL_DIR/include/libgzip" && \
	cp "libgzip.a" "$INSTALL_DIR/lib" && \
	return 0
	return 1
}

sl_cleanup()
{
	return 0
}

. ../mk.sh
