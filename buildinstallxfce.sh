#!/bin/sh

export PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"

for f in *.tar.bz2; do tar -xjf "$f"; done

cd xfce4-dev-tools-4.20.0
./configure --prefix=/usr && make && make install

cd ../libxfce4util-4.20.0/
./configure --prefix=/usr && make && make install

cd ../xfconf-4.20.0
./configure --prefix=/usr && make && make install

cd ../libxfce4ui-4.20.0/
./configure --prefix=/usr && make && make install

cd ../exo-4.20.0/
./configure --prefix=/usr && make && make install

cd ../garcon-4.20.0/
./configure --prefix=/usr && make && make install

cd ../libxfce4windowing-4.20.0
./configure --prefix=/usr && make && make install

cd ../xfce4-panel-4.20.0
./configure --prefix=/usr && make && make install

cd ../xfce4-appfinder-4.20.0
./configure --prefix=/usr && make && make install

cd ../xfce4-session-4.20.0
./configure --prefix=/usr && make && make install

cd ../xfce4-settings-4.20.0
./configure --prefix=/usr && make && make install

cd ../xfwm4-4.20.0/
./configure --prefix=/usr && make && make install

cd ../xfdesktop-4.20.0
./configure --prefix=/usr && make && make install

cd ../xfce4-power-manager-4.20.0
./configure --prefix=/usr && make && make install

cd ../thunar-4.20.0
./configure --prefix=/usr && make && make install

cd ../tumbler-4.20.0
./configure --prefix=/usr && make && make install

cd ../thunar-volman-4.20.0
./configure --prefix=/usr && make && make install

