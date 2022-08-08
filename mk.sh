#!/bin/sh

DOWNLOAD="n"
EXTRACT="n"
BUILD="n"
LINK="n"
CLEANUP="n"
QUIET="n"
JOBS="1"
TARGET="host"
MODE="static"

if [ "$CFLAGS" = "" ]
then
	CFLAGS="-O2 -g"
fi

sl_fetch_www()
{
	if [ ! -f "$2" ]
	then
		echo "downloading $1"
		curl -O "$1" -o "$2"
	fi
}

usage()
{
	echo "build.sh [-h] [-q] [-x] [-b] [-l] [-c] [-j <jobs>] [-t <target>] [-m <mode>] [-o <destination>] [-d]"
	echo "-h:           display this help"
	echo "-q:           quiet mode, display only meta info on progress"
	echo "-x:           extract tar"
	echo "-b:           build"
	echo "-c:           cleanup (rm extracted directory)"
	echo "-j jobs:      set the number of CPU for compilation; default: 1"
	echo "-t target:    set the target (linux_32, linux_64, windows_32, windows_64, host); default: host"
	echo "-m mode:      set the output type (static, shared); default: static"
	echo "-o directory: destination for installed files"
	echo "-d:           download the archive"
}

while getopts 'xblchj:t:qm:o:d' opt
do
	case $opt in
		'x')
			EXTRACT="y"
			;;
		'b')
			BUILD="y"
			;;
		'c')
			CLEANUP="y"
			;;
		'h')
			usage
			exit 0
			;;
		'j')
			JOBS=$OPTARG
			;;
		't')
			TARGET=$OPTARG
			if [ "$TARGET" != "linux_32" -a "$TARGET" != "linux_64" -a "$TARGET" != "windows_32" -a "$TARGET" != "windows_64" -a "$TARGET" != "host" ]
			then
				echo "invalid target"
				usage
				exit 1
			fi
			;;
		'q')
			QUIET="y"
			;;
		'm')
			MODE=$OPTARG
			if [ "$MODE" != "static" -a "$MODE" != "shared" ]
			then
				echo "invalid mode"
				usage
				exit 1
			fi
			;;
		'o')
			INSTALL_DIR=$OPTARG
			;;
		'd')
			DOWNLOAD="y"
			;;
	esac
done

if [ "$QUIET" = "y" ]
then
	echo "$PWD"
fi

if [ "$DOWNLOAD" = "y" ]
then
	if [ "$QUIET" = "y" ]
	then
		echo -n "download.. " && sl_download 2> /dev/null > /dev/null || exit 1
	else
		sl_download || exit 1
	fi
fi

if [ "$EXTRACT" = "n" -a "$BUILD" = "n" -a "$CLEANUP" = "n" ]
then
	exit 0
fi

if [ "$INSTALL_DIR" = "" ]
then
	echo "no destination directory is set"
	exit 1
fi

case "$TARGET" in
	"linux_32")
		HOST="x86_64-linux-gnu"
		ARCH="-m32"
		;;
	"linux_64")
		HOST="x86_64-linux-gnu"
		ARCH="-m64"
		;;
	"windows_32")
		HOST="i686-w64-mingw32"
		ARCH="-m32"
		;;
	"windows_64")
		HOST="x86_64-w64-mingw32"
		ARCH="-m64"
		;;
	"host")
		HOST=`gcc -v 2>&1 | grep Target | cut -d ' ' -f 2`
		ARCH=""
		;;
	*)
		echo "unknown target: $TARGET"
		exit 1
esac

case $MODE in
	"static")
		ENABLE_STATIC="yes"
		ENABLE_SHARED="no"
		;;
	"shared")
		ENABLE_STATIC="no"
		ENABLE_SHARED="yes"
		;;
esac

if [ "$EXTRACT" = "y" ]
then
	if [ "$QUIET" = "y" ]
	then
		echo -n "cleanup.. " && sl_cleanup 2> /dev/null > /dev/null || exit 1
		echo -n "extract.. " && sl_extract 2> /dev/null > /dev/null || exit 1
	else
		sl_cleanup || exit 1
		sl_extract || exit 1
	fi
fi

if [ "$BUILD" = "y" ]
then
	if [ "$QUIET" = "y" ]
	then
		echo -n "build.. " && sl_build 2> /dev/null > /dev/null || exit 1
	else
		sl_build || exit 1
	fi
fi

if [ "$CLEANUP" = "y" ]
then
	if [ "$QUIET" = "y" ]
	then
		echo -n "cleanup.. " && sl_cleanup 2> /dev/null > /dev/null || exit 1
	else
		sl_cleanup || exit 1
	fi
fi

echo
