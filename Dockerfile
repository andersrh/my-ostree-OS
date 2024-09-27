

FROM quay.io/fedora-ostree-desktops/kinoite:40 AS base

ARG CACHEBUST=2


COPY repo/*.repo /etc/yum.repos.d/

# install RPM-fusion
RUN rpm-ostree install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# 32-bit dependencies for the Nvidia driver.
RUN rpm-ostree install glibc.i686

# install nonfree codecs
RUN rpm-ostree override remove libavcodec-free libavfilter-free libavformat-free libavutil-free libpostproc-free libswresample-free libswscale-free libavdevice-free ffmpeg-free --install libavcodec-freeworld

# Install HEIC support for Gwenview and Dolphin (and potentially other applications)
RUN rpm-ostree install libheif-freeworld

# Mesa clang
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:andersrh:my-ostree-os mesa-filesystem mesa-libglapi mesa-dri-drivers mesa-libgbm mesa-libEGL mesa-libGL mesa-vulkan-drivers mesa-libxatracker mesa-vdpau-drivers mesa-libOSMesa mesa-libOpenCL mesa-va-drivers

# 32-bit dependencies for the Nvidia driver.
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:andersrh:my-ostree-os:ml mesa-dri-drivers.i686
RUN rpm-ostree install mesa-filesystem.i686 mesa-libEGL.i686 mesa-libGL.i686 mesa-libgbm.i686 mesa-libglapi.i686 mesa-vulkan-drivers.i686

RUN rpm-ostree install ffmpeg ffmpeg-libs libavdevice intel-media-driver pipewire-codec-aptx libva-intel-driver libva-utils

FROM fedora:40 AS akmods-builder

# Get list of kernels from CachyOS LTO repo. If the list has been updated, then akmods will be rebuilt. If it hasn't been updated, then caching of the previous build will be used.
ADD "https://copr.fedorainfracloud.org/api_3/build/list?ownername=bieszczaders&projectname=kernel-cachyos-lto&packagename=kernel-cachyos-lto" /tmp/builds.txt

RUN dnf -y update && dnf -y install wget

RUN dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Update cachebust in case a rebuild is required without usage of cache.
ARG CACHEBUST=11

RUN cd /etc/yum.repos.d/ && \
wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-lto/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-lto-fedora-$(rpm -E %fedora).repo && \
wget https://copr.fedorainfracloud.org/coprs/andersrh/kernel-cachyos/repo/fedora-$(rpm -E %fedora)/andersrh-kernel-cachyos-fedora-$(rpm -E %fedora).repo && \
wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-addons/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-addons-fedora-$(rpm -E %fedora).repo && \
cd /tmp

RUN dnf -y install kernel-cachyos-lto kernel-cachyos-lto-headers kernel-cachyos-lto-devel kernel-cachyos-lto-modules kernel-cachyos-lto-core kernel-cachyos-lto-devel-matched
RUN dnf -y install akmod-nvidia akmod-VirtualBox

COPY akmods.sh /tmp/akmods.sh
RUN /tmp/akmods.sh

FROM base AS kernel

RUN mkdir /tmp/nvidia

COPY install-nvidia.sh /tmp/install-nvidia.sh

RUN cd /etc/yum.repos.d/ && wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-addons/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-addons-fedora-$(rpm -E %fedora).repo

RUN cd /etc/yum.repos.d/ && \
wget https://copr.fedorainfracloud.org/coprs/andersrh/kernel-cachyos/repo/fedora-$(rpm -E %fedora)/andersrh-kernel-cachyos-fedora-$(rpm -E %fedora).repo && \
wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-lto/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-lto-fedora-$(rpm -E %fedora).repo && \
cd /tmp

# override and upgrade libbpf
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons libbpf

COPY --from=akmods-builder /var/cache/akmods/*/* /tmp/nvidia

# install binutils to get strip command
RUN rpm-ostree install binutils

COPY install_cachyos_kernel.sh /tmp
# Enable cliwrap.
RUN rpm-ostree cliwrap install-to-root / && \
# Replace the kernel, kernel-core and kernel-modules packages.
/tmp/install_cachyos_kernel.sh

# install kernel headers
RUN rpm-ostree install kernel-cachyos-lto-headers

# install akmods
RUN ls /tmp/nvidia && /tmp/install-nvidia.sh

RUN rpm-ostree install \
    xorg-x11-drv-nvidia{,-cuda,-devel,-kmodsrc} \
    xorg-x11-drv-nvidia-libs.i686 \
    nvidia-container-toolkit supergfxctl supergfxctl-plasmoid

RUN mv /etc/nvidia-container-runtime/config.toml{,.orig}

RUN systemctl enable supergfxd.service

RUN rpm-ostree uninstall xorg-x11-drv-nvidia-power

RUN ln -s /usr/bin/ld.bfd /etc/alternatives/ld
RUN ln -s /etc/alternatives/ld /usr/bin/ld

# install Nvidia software
RUN rpm-ostree install nvidia-vaapi-driver nvidia-persistenced opencl-filesystem

# Clear cache, /var and /tmp and commit ostree
RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit


FROM kernel AS os

ARG CACHEBUST=5

RUN cd /tmp && \
rpm-ostree cleanup -m && rpm-ostree install ksshaskpass cronie distrobox fish lld nvtop seadrive-gui pulseaudio-utils hfsplus-tools VirtualBox

# Add docker-compose dependency for "podman compose" command
RUN rpm-ostree install docker-compose

# Add docker -> podman alias for docker-compose to work properly
RUN ln -s /usr/bin/podman /usr/bin/docker

# Disable SELinux
RUN sed -i "s/^SELINUX=.*$/SELINUX=permissive/g" /etc/sysconfig/selinux && sed -i "s/^SELINUX=.*$/SELINUX=permissive/g" /etc/selinux/config

# Xwayland clang
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:andersrh:my-ostree-os xorg-x11-server-Xwayland

# add Haruna media player to host for better VAAPI performance
RUN rpm-ostree install haruna

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
