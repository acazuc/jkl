#!/bin/sh

NAME="nghttp2"
VERSION="1.48.0"

TAR="$NAME-$VERSION.tar.xz"
SRCDIR="$NAME-$VERSION"

sl_download()
{
	sl_fetch_www "https://github.com/nghttp2/nghttp2/releases/download/v$VERSION/$TAR" "$TAR"
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
			SYSTEM_NAME="Linux"
			;;
		"linux_64")
			SYSTEM_NAME="Linux"
			;;
		"windows_32")
			SYSTEM_NAME="Windows"
			;;
		"windows_64")
			SYSTEM_NAME="Windows"
			;;
		"host")
			SYSTEM_NAME=""
			;;
	esac
	cd "$SRCDIR" && \
	cmake -DENABLE_STATIC_LIB=$ENABLE_STATIC -DENABLE_SHARED_LIB=$ENABLE_SHARED -DENABLE_LIB_ONLY=ON -DCMAKE_SYSTEM_NAME=$SYSTEM_NAME -DCMAKE_C_COMPILER="$HOST-gcc" -DCMAKE_CXX_COMPILER="$HOST-g++" -DCMAKE_C_FLAGS="$CFLAGS $ARCH" -DCMAKE_CXX_FLAGS="$CFLAGS $ARCH" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" . && \
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
