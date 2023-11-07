FROM ghcr.io/andersrh/containers/cachyos/base-gui:main

WORKDIR /app

COPY containers/cachyos/ledgerlive/ledger-live-bin /app/ledger-live-bin
COPY containers/cachyos/ledgerlive/ledger-udev /app/ledger-udev

RUN chown -R build /app

USER build

RUN cd ledger-udev \
&& makepkg -si --noconfirm

RUN cd ledger-live-bin \
&& makepkg -si --noconfirm \
&& rm -rf /app/*
USER root

