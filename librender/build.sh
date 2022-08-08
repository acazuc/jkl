#!/bin/sh

NAME="librender"

SRCDIR="librender"

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
	make CXX="$HOST-g++" CXXFLAGS="$ARCH -fno-rtti" AR="$HOST-ar" RANLIB="$HOST-ranlib" INCLUDES="-I $INSTALL_DIR/include -I $INSTALL_DIR/include/freetype2" -j $JOBS && \
	mkdir -p "$INSTALL_DIR/include/librender" && \
	cp -R src/* "$INSTALL_DIR/include/librender" && \
	cp "librender.a" "$INSTALL_DIR/lib" && \
	return 0
	return 1
}

sl_cleanup()
{
	return 0
}

. ../mk.sh
