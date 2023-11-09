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
RUN pacman -Sy --noconfirm qt6-webengine
