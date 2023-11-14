FROM ghcr.io/andersrh/containers/cachyos/base-gui:main

WORKDIR /app

USER build
RUN yay -Sy --noconfirm lbry-desktop-bin
USER root
