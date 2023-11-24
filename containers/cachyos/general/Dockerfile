FROM ghcr.io/andersrh/containers/cachyos/base-gui:main

WORKDIR /app

RUN pacman -Sy --noconfirm yt-dlp mesa-utils whois

COPY containers/general/bin/* /usr/local/bin/
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/flatpak
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/podman
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/nvtop
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/distrobox
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/uksmdstats
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/kerver
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/mullvad
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/mullvad-exclude
