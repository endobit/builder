#! /bin/sh
#
# Usage: arch
#
# Prints the cpu architecture.

if command -v uname >/dev/null 2>&1; then
    ARCH="$(uname -m)"
fi

case "$ARCH" in
    i386|i486|i586|i686)
        echo amd
        ;;
	x86_64)
		echo amd64
		;;
    armv7l)
        echo armv7hl
        ;;
    *)
        echo "$ARCH"
        ;;
esac


