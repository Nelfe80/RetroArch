#!/bin/bash
# Configure RetroArch NelfePlay (MSYS2 MINGW64, prefixe de deps tire des DLL de la borne). Lance depuis le depot.
set -e
DEPS=/e/claude_travail/temp/retroarch_nelfeplay/deps/prefix
export PKG_CONFIG_LIBDIR=$DEPS/lib/pkgconfig
export PKG_CONFIG_PATH=
export TEMP=/e/claude_travail/temp TMP=/e/claude_travail/temp TMPDIR=/e/claude_travail/temp
export LDFLAGS="-static-libgcc -static-libstdc++"
./configure --disable-qt --disable-ssa --enable-builtinzlib --disable-libusb --disable-sdl --enable-sdl2 \
  --enable-ffmpeg --enable-freetype "$@"
