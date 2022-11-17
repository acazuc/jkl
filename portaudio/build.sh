#!/bin/sh

NAME="pa"
VERSION="stable_v190600_20161030"

TAR="${NAME}_${VERSION}.tgz"
SRCDIR="${NAME}_${VERSION}"

sl_download()
{
	sl_fetch_www "http://files.portaudio.com/archives/$TAR" "$TAR"
}

sl_extract()
{
	tar xf "$TAR"
	mv "portaudio" "$SRCDIR"
	ln -sf "$SRCDIR" "$NAME"
}

sl_build()
{
	case $TARGET in
		"linux_32")
			API="--with-alsa --without-jack --without-oss"
			;;
		"linux_64")
			API="--with-alsa --without-jack --without-oss"
			;;
		"windows_32")
			API="--with-winapi=directx"
			;;
		"windows_64")
			API="--with-winapi=directx"
			;;
		"host")
			;;
	esac
	cd "$SRCDIR" && \
	sh configure --enable-static=$ENABLE_STATIC --enable-shared=$ENABLE_SHARED CFLAGS="$CFLAGS $ARCH" --host="$HOST" $API --prefix="$INSTALL_DIR" --exec-prefix="$INSTALL_DIR" && \
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
