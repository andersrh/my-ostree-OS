FROM ghcr.io/andersrh/containers/cachyos/base-gui:main

WORKDIR /app

USER build
#RUN yay -Sy --noconfirm vscodium-bin
RUN git clone https://aur.archlinux.org/vscodium-bin.git \
&& cd vscodium-bin \
&& makepkg -si --noconfirm \
&& rm -rf /app/*
USER root

RUN pacman -Sy --noconfirm qtcreator python-lsp-server

RUN pip3 install pip2pkgbuild python-binance pyside6 --break-system-packages
RUN chown -R build /app
RUN mkdir /app/sqlalchemy && chown -R build /app/sqlalchemy
RUN mkdir /app/telethon && chown -R build /app/telethon
USER build
# python-binance sqlalchemy telethon pyside6

WORKDIR /app/sqlalchemy
RUN pip2pkgbuild sqlalchemy
RUN makepkg -si --noconfirm

WORKDIR /app/telethon
RUN pip2pkgbuild telethon
RUN makepkg -si --noconfirm

RUN rm -rf /app/*
USER root
