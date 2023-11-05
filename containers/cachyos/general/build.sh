#!/bin/sh

APPNAME="general"

podman build -t andersrh/cachyos/$APPNAME -f cachyos.Dockerfile .
podman rm -f $APPNAME-cachyos
distrobox create --image andersrh/cachyos/$APPNAME --home ~/containers/$APPNAME/ $APPNAME-cachyos

distrobox enter $APPNAME-cachyos -- distrobox-export --app codium
