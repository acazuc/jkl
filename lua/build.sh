#!/bin/sh

NAME="lua"
#VERSION="5.4.2"
VERSION="5.1.5"
SOVER="0"

TAR="$NAME-$VERSION.tar.gz"
SRCDIR="$NAME-$VERSION"

sl_download()
{
	sl_fetch_www "https://www.lua.org/ftp/$TAR" "$TAR"
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
			TO_BIN="lua luac"
			;;
		"linux_64")
			TO_BIN="lua luac"
			;;
		"windows_32")
			TO_BIN="lua.exe luac.exe"
			;;
		"windows_64")
			TO_BIN="lua.exe luac.exe"
			;;
		"host")
			TO_BIN="lua luac"
			;;
	esac
	case $MODE in
		"static")
			SHARED_FLAGS=""
			;;
		"shared")
			SHARED_FLAGS="-fPIC"
			sed -i 's/\$(RANLIB) $@/$(CC) -shared -ldl -Wl,-soname,liblua$R.so -o liblua$R.so $? -lm $(MYLDFLAGS)/' "$SRCDIR/src/Makefile"
			;;
	esac
	sed -i "s/MYCFLAGS=/MYCFLAGS=$MYCFLAGS/g" "$SRCDIR/src/Makefile" && \
	cd "$SRCDIR" && \
	make clean && \
	make -C src all CC="$HOST-gcc" AR="$HOST-ar rcu" RANLIB="$HOST-ranlib" MYCFLAGS="$CFLAGS $ARCH $SHARED_FLAGS" MYLDFLAGS="$ARCH $CFLAGS" -j "$JOBS" && \
	make install -j "$JOBS" INSTALL_TOP="$INSTALL_DIR" TO_BIN="$TO_BIN" && \
	return 0
	return 1;
}

sl_cleanup()
{
	rm -rf "$SRCDIR"
}

. ../mk.sh
