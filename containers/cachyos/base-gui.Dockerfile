FROM docker.io/cachyos/cachyos-v3

WORKDIR /app
COPY etc /etc

RUN pacman -Syu --noconfirm --needed git base-devel
RUN useradd -m --shell=/bin/false build && usermod -L build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown -R build /app
RUN pacman -Sy --noconfirm yay bash bc curl diffutils findutils gnupg less lsof ncurses pinentry procps-ng shadow sudo time util-linux wget vte-common
RUN pacman -Sy --noconfirm fish htop
RUN pacman -Sy --noconfirm libva libva-intel-driver libva-mesa-driver libva-utils intel-media-driver
RUN pacman -Sy --noconfirm mesa opengl-driver vulkan-intel vulkan-radeon
RUN pacman -Sy --noconfirm nss atk cups gtk3 alsa-lib
RUN pacman -Sy --noconfirm xdg-utils
RUN pacman -Sy --noconfirm nano ibus dbus-glib
RUN pacman -Sy --noconfirm ttf-dejavu noto-fonts ttf-liberation
RUN pacman -Sy --noconfirm nvidia-utils
RUN pacman -Sy --noconfirm squashfs-tools python-pyasn1 python-pip qt6-wayland

RUN pacman -Sy --noconfirm opencl-nvidia
RUN pacman -Sy --noconfirm libxss
RUN pacman -Sy --noconfirm xorg-xwininfo python-setuptools python-pyaes python-rsa python-certifi
RUN pip3 install pip2pkgbuild python-binance pyside6 --break-system-packages
RUN chown -R build /app
RUN mkdir /app/sqlalchemy && chown -R build /app/sqlalchemy
RUN mkdir /app/telethon && chown -R build /app/telethon
USER build
# python-binance sqlalchemy telethon pyside6

WORKDIR /app/sqlalchemy
RUN pip2pkgbuild sqlalchemy
RUN makepkg -si --noconfirm

WORKDIR /app/telethon
RUN pip2pkgbuild telethon
RUN makepkg -si --noconfirm

RUN rm -rf /app/*
USER root
