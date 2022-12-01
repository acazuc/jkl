#!/bin/sh

org_pwd=$PWD

if [ "$SL_LIBS" = "" ]
then
	SL_LIBS="zlib libpng freetype glfw glad openssl lua libxml2 nghttp2 nghttp3 curl libogg libflac libvorbis portaudio jansson libunicode libgzip libnet librender libaudio libformat jks gfx libsamplerate"
fi

for lib in $SL_LIBS
do
	cd "$org_pwd/$lib" && sh build.sh $@ && continue
	echo "$lib failed"
	exit 1
done
