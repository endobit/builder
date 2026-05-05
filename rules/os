#! /bin/sh
#
# Usage: os [--dist]
#
# Prints the operating system name. If --dist is given, prints the distribution name.

if command -v uname >/dev/null 2>&1; then
    OS="$(uname)"
fi

function os() {
	case "$OS" in
		Linux)
			echo linux
			;;
		Darwin)
			echo macos
			;;
		*)
			echo unknown
			;;
	esac
}

function os_dist() {
	case "$OS" in
		Linux)
			if [ -f /etc/os-release ]; then
				. /etc/os-release
				case "$ID" in
					rhel|centos|rocky|almalinux)
						echo redhat
						;;
					sles|opensuse*|suse)
						echo sles
						;;
					debian|ubuntu)
						echo debian
						;;
					*)
						echo linux
						;;
				esac
			else
				echo linux
			fi
			;;
		*)
			;;
	esac
}

if [ "$1" = "--dist" ]; then
	os_dist
else
	os
fi

