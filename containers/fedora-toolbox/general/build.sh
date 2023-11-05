#!/bin/sh

APPNAME="general"

podman build -t andersrh/fedora-toolbox/$APPNAME -f fedora.Dockerfile .
#toolbox create --image andersrh/fedora-toolbox/$APPNAME $APPNAME
distrobox create --image andersrh/fedora-toolbox/$APPNAME --home ~/containers/$APPNAME/ $APPNAME
distrobox create --image andersrh/fedora-toolbox/$APPNAME --init --home ~/containers/$APPNAME/ $APPNAME-systemd

distrobox enter $APPNAME -- distrobox-export --app x2goclient
distrobox enter $APPNAME -- distrobox-export --app qtcreator

distrobox create --image andersrh/fedora-toolbox/$APPNAME $APPNAME-defaulthome
distrobox enter $APPNAME-defaulthome -- distrobox-export --app gnome-tweaks
