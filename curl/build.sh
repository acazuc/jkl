#!/bin/sh

NAME="curl"
VERSION="7.84.0"

TAR="$NAME-$VERSION.tar.xz"
SRCDIR="$NAME-$VERSION"

sl_download()
{
	sl_fetch_www "https://curl.se/download/$TAR" "$TAR"
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
			SSL="--with-openssl"
			;;
		"linux_64")
			SSL="--with-openssl"
			;;
		"windows_32")
			SSL="--with-schannel"
			;;
		"windows_64")
			SSL="--with-schannel"
			;;
	esac
	case $MODE in
		"static")
			CFLAGS="$CFLAGS -DNGHTTP2_STATICLIB"
			;;
		"shared")
			;;
	esac
	cd $SRCDIR && \
	sh configure --enable-debug --enable-optimize --enable-warnings --enable-werrors \
	             --disable-rt --enable-http --disable-telnet --disable-tftp \
	             --disable-pop3 --disable-imap --disable-smtp --enable-ftp \
	             --disable-rtsp --disable-gopher --disable-dict --disable-smb \
	             --disable-ldap --enable-ipv6 --disable-threaded-resolver \
	             --disable-pthreads $SSL --without-brotli --without-zstd --with-zlib \
	             --without-libpsl --without-librtmp --without-winidn --without-libidn2 \
	             --with-nghttp2 --with-nghttp3 --without-zsh-functions \
	             --enable-static=$ENABLE_STATIC --enable-shared=$ENABLE_SHARED \
	             --host="$HOST" --prefix="$INSTALL_DIR" --exec-prefix="$INSTALL_DIR" \
	             CFLAGS="$CFLAGS $ARCH" PKG_CONFIG_PATH="$INSTALL_DIR/lib/pkgconfig" && \
	make clean && \
	make -C "lib" -j "$JOBS" && \
	make install -j "$JOBS" && \
	return 0
	return 1
}

sl_cleanup()
{
	rm -rf "$SRCDIR"
}

. ../mk.sh
