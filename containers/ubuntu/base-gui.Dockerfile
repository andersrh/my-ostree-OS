FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y
RUN apt install -y fish htop nano firejail bash apt-utils bc curl dialog diffutils findutils gnupg2 less libnss-myhostname libvte-2.91-common libvte-common lsof ncurses-base passwd pinentry-curses procps sudo time wget util-linux libegl1-mesa libgl1-mesa-glx libvulkan1 mesa-vulkan-drivers libva2 libva-wayland2 libva-glx2 libva-drm2 libva-x11-2 intel-media-va-driver va-driver-all
RUN apt install -y gconf2 gconf-service libnotify4 libappindicator1 libnss3 libsecret-1-dev gnome-keyring
RUN apt install -y libasound2 libgles2


# Link xdg-open to host in order to be able to open links etc.
RUN rm -f /usr/bin/xdg-open && ln -s /usr/bin/distrobox-host-exec /usr/bin/xdg-open

# Install host-spawn
RUN wget https://github.com/1player/host-spawn/releases/download/1.5.0/host-spawn-x86_64 -O /usr/bin/host-spawn && chmod +x /usr/bin/host-spawn

RUN apt clean
