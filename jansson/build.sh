#!/bin/sh

NAME="jansson"
VERSION="2.14"

TAR="$NAME-$VERSION.tar.gz"
SRCDIR="jansson-$VERSION"

sl_download()
{
	sl_fetch_www "https://github.com/akheron/jansson/releases/download/v$VERSION/$TAR" "$TAR"
}

sl_extract()
{
	tar -xf "$TAR"
	ln -sf "$SRCDIR" "$NAME"
}

sl_build()
{
	case $MODE in
		"static")
			BUILD_SHARED_LIBS="no"
			;;
		"shared")
			BUILD_SHARED_LIBS="yes"
			;;
	esac
	cd "$SRCDIR" && \
	cmake -DBUILD_SHARED_LIBS=$BUILD_SHARED_LIBS -DCMAKE_C_FLAGS="$CFLAGS $ARCH" -DJANSSON_WITHOUT_TESTS=ON -DJANSSON_EXAMPLES=OFF -DJANSSON_BUILD_DOCS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" . && \
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
