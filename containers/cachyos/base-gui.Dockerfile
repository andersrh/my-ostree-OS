FROM docker.io/cachyos/cachyos-v3

WORKDIR /app
COPY etc /etc

RUN pacman -Syu --noconfirm --needed git base-devel
RUN useradd -m --shell=/bin/false build && usermod -L build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown -R build /app
RUN pacman -Sy --noconfirm yay bash bc curl diffutils findutils gnupg less lsof ncurses pinentry procps-ng shadow sudo time util-linux wget vte-common fuse
RUN pacman -Sy --noconfirm fish htop
RUN pacman -Sy --noconfirm libva libva-intel-driver libva-mesa-driver libva-utils intel-media-driver
RUN pacman -Sy --noconfirm mesa opengl-driver vulkan-intel vulkan-radeon
RUN pacman -Sy --noconfirm nss atk cups gtk3 alsa-lib
RUN pacman -Sy --noconfirm xdg-utils
RUN pacman -Sy --noconfirm nano ibus dbus-glib
RUN pacman -Sy --noconfirm ttf-dejavu noto-fonts ttf-liberation
RUN pacman -Sy --noconfirm nvidia-utils
RUN pacman -Sy --noconfirm squashfs-tools python-pyasn1 python-pip qt6-wayland qt5-wayland

RUN pacman -Sy --noconfirm opencl-nvidia
RUN pacman -Sy --noconfirm libxss
RUN pacman -Sy --noconfirm xorg-xwininfo python-setuptools python-pyaes python-rsa python-certifi
RUN pacman -Sy --noconfirm qt6-webengine
# Add Bitwarden dependencies
RUN pacman -Sy --noconfirm electron25 c-ares jsoncpp libnss_nis woff2

# Link xdg-open to host in order to be able to open links etc.
RUN rm -f /usr/bin/xdg-open && ln -s /usr/bin/distrobox-host-exec /usr/bin/xdg-open

# Install host-spawn
RUN wget https://github.com/1player/host-spawn/releases/download/1.5.0/host-spawn-x86_64 -O /usr/bin/host-spawn && chmod +x /usr/bin/host-spawn

# Add Chaotic-AUR
RUN pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com && \
pacman-key --lsign-key 3056513887B78AEB && \
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' && \
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' &&\
echo -en "\n\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n" >> /etc/pacman.conf
