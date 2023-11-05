#!/bin/sh

APPNAME="tradingview"

podman build -t andersrh/cachyos/$APPNAME -f Dockerfile .
podman rm -f $APPNAME
distrobox create --image ghcr.io/andersrh/containers/cachyos/$APPNAME --home ~/containers/$APPNAME/ $APPNAME
distrobox enter $APPNAME -- distrobox-export --app $APPNAME --extra-flags "--enable-features=WaylandWindowDecorations --ozone-platform=wayland"
