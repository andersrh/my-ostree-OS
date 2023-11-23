FROM ghcr.io/andersrh/containers/cachyos/base-gui:main

WORKDIR /app

COPY containers/cachyos/electron-cash/electron-cash /app/electron-cash

RUN chown -R build /app

RUN pacman -Sy --noconfirm python-btchip python-hidapi zbar python-matplotlib

USER build

RUN cd electron-cash \
&& makepkg -si --noconfirm \
&& rm -rf /app/*
USER root

