#!/bin/sh

NAME="gfx"
VERSION="1.0.0"

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
	case $TARGET in
		"linux_32")
			OPT="--enable-device-gl3 --enable-device-gl4 --enable-window-x11 --enable-window-glfw"
			;;
		"linux_64")
			OPT="--enable-device-gl3 --enable-device-gl4 --enable-window-x11 --enable-window-glfw"
			;;
		"windows_32")
			OPT="--enable-device-gl3 --enable-device-gl4 --enable-device-d3d11 --enable-window-win32 --enable-window-glfw"
			;;
		"windows_64")
			OPT="--enable-device-gl3 --enable-device-gl4 --enable-device-d3d11 --enable-window-win32 --enable-window-glfw"
			;;
		"host")
			OPT="--enable-device-gl3 --enable-device-gl4 --enable-window-x11 --enable-window-glfw"
			;;
	esac
	pwd=$PWD
	cd "$SRCDIR" && \
	sh autogen.sh && \
	sh configure CFLAGS="$CFLAGS $ARCH" CPPFLAGS="-I$INSTALL_DIR/include" LDFLAGS="-L$INSTALL_DIR/lib" --enable-static="$ENABLE_STATIC" --enable-shared="$ENABLE_SHARED" --host=$HOST --prefix="$INSTALL_DIR" --exec-prefix="$INSTALL_DIR" $OPT && \
	make clean && \
	make -j $JOBS && \
	make install -j $JOBS && \
	return 0
	return 1
}

sl_cleanup()
{
	return 0
}

. ../mk.sh
