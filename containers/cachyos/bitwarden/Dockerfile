FROM ghcr.io/andersrh/containers/cachyos/base-gui:main

WORKDIR /app

RUN pacman -Sy --noconfirm bitwarden

RUN sed -i 's/app.asar/app.asar --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations/' /usr/bin/bitwarden-desktop
