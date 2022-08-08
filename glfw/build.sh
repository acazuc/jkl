#!/bin/sh

NAME="glfw"
VERSION="3.3.6"

TAR="$NAME-$VERSION.zip"
SRCDIR="$NAME-$VERSION"

sl_download()
{
	sl_fetch_www "https://github.com/glfw/glfw/releases/download/$VERSION/$TAR" "$TAR"
}

sl_extract()
{
	unzip -u "$TAR" > /dev/null
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
	cp "files/x86_64-linux-gnu.cmake" "$SRCDIR/CMake" && \
	cd "$SRCDIR" && \
	cmake -DBUILD_SHARED_LIBS=$BUILD_SHARED_LIBS -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF -DCMAKE_C_FLAGS="$CFLAGS $ARCH" -DCMAKE_TOOLCHAIN_FILE="CMake/$HOST.cmake" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" . && \
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
