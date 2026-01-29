#!/bin/sh

export PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"

tar -xf xfce4-whiskermenu-plugin-2.10.0.tar.xz
cd xfce4-whiskermenu-plugin-2.10.0
meson setup build
meson compile -C build
meson install -C build

cd ../

tar -xf xfce4-pulseaudio-plugin-0.5.1.tar.xz
cd xfce4-pulseaudio-plugin-0.5.1
./autogen.sh --prefix=/usr && make && make install

cd ../

tar -xf xfce4-mixer-4.20.0.tar.xz
cd xfce4-mixer-4.20.0
./autogen.sh --prefix=/usr && make && make install

cd ../

tar -xjf xfce4-notifyd-0.9.7.tar.bz2
cd xfce4-notifyd-0.9.7
./configure --prefix=/usr && make && make install

cd ../

tar -xf xfce4-clipman-plugin-1.7.0.tar.xz
cd xfce4-clipman-plugin-1.7.0
./autogen.sh --prefix=/usr && make && make install