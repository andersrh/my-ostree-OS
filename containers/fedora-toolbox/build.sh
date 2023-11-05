#!/bin/sh

podman build -t andersrh/fedora-toolbox/base-gui -f base-gui.Dockerfile .
podman tag localhost/andersrh/fedora-toolbox/base-gui:latest localhost/andersrh/fedora-toolbox/base-gui:39
# podman build -t andersrh/fedora-toolbox/gui -f gui.Dockerfile .
