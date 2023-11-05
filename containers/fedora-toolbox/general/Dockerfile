FROM ghcr.io/andersrh/containers/fedora-toolbox/base-gui:main

WORKDIR /app

RUN dnf install -y xwininfo yt-dlp neofetch dnstop fedmod flatpak-module-tools fedpkg net-tools x2goclient qt-creator

COPY bin/* /usr/local/bin/
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/flatpak
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/podman
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/nvtop
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/distrobox
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/uksmdstats
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/kerver
