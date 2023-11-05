#!/bin/sh

podman pull docker.io/cachyos/cachyos-v3
podman build -t andersrh/cachyos/base-gui -f base-gui.Dockerfile .
