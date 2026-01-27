#!/bin/sh

export PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"

tar -xf xfce4-mixer-4.20.0.tar.xz
cd xfce4-mixer-4.20.0
./autogen.sh --prefix=/usr && make && make install
