#!/bin/sh

NAME="libunicode"

SRCDIR="libunicode"

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
	mkdir -p "$INSTALL_DIR/include/libunicode" && \
	cp -R src/* "$INSTALL_DIR/include/libunicode" && \
	return 0
	return 1
}

sl_cleanup()
{
	return 0
}

. ../mk.sh
