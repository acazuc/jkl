#!/bin/sh

NAME="glad"
VERSION="4.6"

TAR="$NAME-$VERSION.zip"
SRCDIR="$NAME-$VERSION"

sl_download()
{
	return 0
}

sl_extract()
{
	unzip -u -d "$SRCDIR" "glad-$VERSION.zip" > /dev/null
	ln -sf "$SRCDIR" "$NAME"
}

sl_build()
{
	cd "$SRCDIR" && \
	$HOST-gcc $CFLAGS $ARCH -I "include" -c "src/glad.c" -o "src/glad.o" && \
	$HOST-ar -rc "libglad.a" "src/glad.o" && \
	cp libglad.a "$INSTALL_DIR/lib" && \
	cp -R include/* "$INSTALL_DIR/include" && \
	return 0
	return 1
}

sl_cleanup()
{
	rm -rf "$SRCDIR"
}

. ../mk.sh
