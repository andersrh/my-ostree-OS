ARG IMAGE_NAME="${IMAGE_NAME:-kinoite}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-kinoite}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

RUN cd /etc/yum.repos.d/ && \
wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-fedora-$(rpm -E %fedora).repo && \
wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-addons/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-addons-fedora-$(rpm -E %fedora).repo

RUN cd /tmp && wget https://mullvad.net/da/download/app/rpm/latest -O mullvad.rpm

RUN rpm-ostree override remove firefox firefox-langpacks && \
rpm-ostree override remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra --install kernel-cachyos-bore-lto && \
rpm-ostree install /tmp/mullvad.rpm uksmd clang clang-devel cronie distrobox fish flatpak-builder gparted libcap-ng-devel libvirt-daemon-driver-lxc libvirt-daemon-lxc lld llvm nvtop procps-ng-devel seadrive-gui virt-manager waydroid && \ 
rpm-ostree cleanup -m && \
rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit