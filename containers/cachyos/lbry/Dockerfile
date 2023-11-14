FROM ghcr.io/andersrh/containers/cachyos/base-gui:main

WORKDIR /app

USER build
RUN git clone https://aur.archlinux.org/lbry-desktop-bin.git \
&& cd lbry-desktop-bin \
&& makepkg -si --noconfirm \
&& rm -rf /app/*
USER root

#RUN pacman -Sy --noconfirm lbry-desktop-bin
