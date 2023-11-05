FROM ghcr.io/andersrh/containers/cachyos/base-gui:main

WORKDIR /app

USER build
RUN git clone https://aur.archlinux.org/tradingview.git \
&& cd tradingview \
&& makepkg -si --noconfirm \
&& rm -rf /app/*
USER root

COPY create_shortcut /usr/local/bin/create_shortcut
