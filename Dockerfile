ARG IMAGE_NAME="${IMAGE_NAME:-kinoite}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-kinoite}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"


FROM ghcr.io/andersrh/my-ostree-os-kernel-akmods:main-39 AS builder

ARG CACHEBUST=4
ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

RUN cd /tmp && \
rpm-ostree install ksshaskpass cronie distrobox fish lld nvtop seadrive-gui pulseaudio-utils hfsplus-tools VirtualBox

# Add docker-compose dependency for "podman compose" command
RUN rpm-ostree install docker-compose

# Add docker -> podman alias for docker-compose to work properly
RUN ln -s /usr/bin/podman /usr/bin/docker

# Disable SELinux
RUN sed -i "s/^SELINUX=.*$/SELINUX=permissive/g" /etc/sysconfig/selinux && sed -i "s/^SELINUX=.*$/SELINUX=permissive/g" /etc/selinux/config

# Xwayland clang
RUN cd /etc/yum.repos.d/ && wget https://copr.fedorainfracloud.org/coprs/trixieua/mutter-patched/repo/fedora-$(rpm -E %fedora)/trixieua-mutter-patched-fedora-$(rpm -E %fedora).repo && rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:trixieua:mutter-patched xorg-x11-server-Xwayland

# add Haruna media player to host for better VAAPI performance
RUN rpm-ostree install haruna

# software to be replaced with clang version
RUN rpm-ostree override replace --experimental --from repo=fedora-clang podman tar kpipewire NetworkManager-libnm NetworkManager NetworkManager-vpnc NetworkManager-wwan NetworkManager-wifi NetworkManager-ppp NetworkManager-bluetooth NetworkManager-config-connectivity-fedora wayland-utils xz xz-libs gzip bzip2-libs bzip2 libzip libarchive rsync libva dbus-broker dbus-glib wget dbusmenu-qt

# Install AppImageLauncher
RUN rpm-ostree install https://github.com/TheAssassin/AppImageLauncher/releases/download/continuous/appimagelauncher-2.2.0-gha111.d9d4c73.x86_64.rpm

# Install Gwenview on host for full support for image formats such as HEIC
RUN rpm-ostree install gwenview

# add cachyos-settings, uksmd and scx-scheds-git
RUN rpm-ostree install uksmd scx-scheds-git libcap-ng-devel procps-ng-devel
RUN rpm-ostree override remove zram-generator-defaults --install cachyos-settings

# enable systemd services

RUN systemctl enable uksmd.service
RUN systemctl enable scx.service

# Copy config files
COPY etc /etc
# Copy /usr
COPY usr /usr

# Enable /nix mount service
RUN systemctl enable mount-nix-prepare.service

# Clear cache, /var and /tmp and commit ostree
RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit
