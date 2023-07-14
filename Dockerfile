ARG IMAGE_NAME="${IMAGE_NAME:-kinoite}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-kinoite}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

RUN rpm-ostree override remove firefox firefox-langpacks && \
rpm-ostree install clang clang-devel cronie distrobox fish flatpak-builder gparted libcap-ng-devel libvirt-daemon-driver-lxc libvirt-daemon-lxc lld llvm nvtop procps-ng-devel seadrive-gui virt-manager waydroid && \ 
rpm-ostree cleanup -m && \
ostree container commit