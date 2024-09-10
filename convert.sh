#!/bin/sh
# Convert your suckless builds from linux to FreeBSD
# Add dependency installs for each program for FreeBSD
# Based on swindlemccoop's script and patches for same purpose on OpenBSD
# Run as root or with doas

_deps_dwm() {
	echo "Installing dependencies for dwm..."
	pkg install -y libx11
}

_deps_dwmblocks() {
	echo "Installing dependencies for dwmblocks..."
	pkg install -y libx11
}

_deps_st() {
	echo "Installing dependencies for st..."
	pkg install -y libx11
}

_deps_dmenu() {
	echo "Installing dependencies for dmenu..."
	pkg install -y libx11
	pkg install -y libxinerama
	pkg install -y libxft
}

_conv() {
	echo "VARIABLE IS"
	echo $2
	case "$2" in
		dwm) _deps_dwm ;;
		dmwblocks) _deps_dwmblocks ;;
		st) _deps_st ;;
		dmenu_config.mk) _deps_dmenu ;;
	esac
	mv "$SUCKPATH/$1" "$SUCKPATH/$1.linux"
	cp patches/$2 "$SUCKPATH/$1"
	printf "Build at \033[0;34m$(readlink -f $SUCKPATH)\033[0m has been \033[0;32msuccessfully patched\033[0m.\n"
}

_help() {
	printf "Usage: convert.sh [program]\nSee README.md for more details.\n"
	exit 1
}

case $1 in
	dwm|dwmblocks|st|dmenu) true ;;
	*) _help ;;
esac

printf "Please input path to the build you wish to convert (can be relative or absolute): "
read -r SUCKPATH
[ -d "$SUCKPATH" ] || {
	printf "\033[0;31mError: directory does not exist.\033[0m\n"
	exit 1
}

case "$1" in
	dwm) _conv config.mk dwm_config.mk ;;
	dwmblocks) _conv Makefile dwmblocks_Makefile ;;
	st) _conv config.mk st_config.mk ;;
	dmenu) _conv config.mk dmenu_config.mk ;;
esac
