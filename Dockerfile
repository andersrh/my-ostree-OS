FROM fedora:41 AS akmods-builder

ARG KERNEL=kernel-cachyos-lto-skylake
ENV KERNEL=${KERNEL}

# Get list of kernels from CachyOS LTO repo. If the list has been updated, then akmods will be rebuilt. If it hasn't been updated, then caching of the previous build will be used.
ADD "https://copr.fedorainfracloud.org/api_3/build/list?ownername=andersrh&projectname=my-ostree-os&packagename=kernel-cachyos-lto-skylake" /tmp/builds.txt

# Install necessary tools to build kernel modules
RUN dnf -y update && dnf -y install wget clang polly

RUN dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Update cachebust in case a rebuild is required without usage of cache.
ARG CACHEBUST=11

RUN cd /etc/yum.repos.d/ && \
wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-lto/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-lto-fedora-$(rpm -E %fedora).repo && \
wget https://copr.fedorainfracloud.org/coprs/andersrh/kernel-cachyos/repo/fedora-$(rpm -E %fedora)/andersrh-kernel-cachyos-fedora-$(rpm -E %fedora).repo && \
wget https://copr.fedorainfracloud.org/coprs/andersrh/my-ostree-os/repo/fedora-$(rpm -E %fedora)/andersrh-my-ostree-os-fedora-$(rpm -E %fedora).repo && \
wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-addons/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-addons-fedora-$(rpm -E %fedora).repo && \
wget https://negativo17.org/repos/fedora-nvidia.repo && \
cd /tmp

RUN dnf -y install ${KERNEL} ${KERNEL}-devel ${KERNEL}-modules ${KERNEL}-core ${KERNEL}-devel-matched
RUN dnf -y install akmod-VirtualBox

COPY akmods.sh /tmp/akmods.sh
RUN /tmp/akmods.sh ${KERNEL}

FROM quay.io/fedora-ostree-desktops/kinoite:41 AS base

ARG CACHEBUST=5

RUN mkdir /tmp/nvidia

COPY install-nvidia.sh /tmp/install-nvidia.sh

COPY --from=akmods-builder /var/cache/akmods/*/* /tmp/nvidia

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
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:andersrh:my-ostree-os mesa-filesystem mesa-dri-drivers mesa-libgbm mesa-libEGL mesa-libGL mesa-vulkan-drivers mesa-libxatracker mesa-vdpau-drivers mesa-libOSMesa mesa-libOpenCL mesa-va-drivers

# 32-bit dependencies for the Nvidia driver.
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:andersrh:my-ostree-os:ml mesa-dri-drivers.i686
RUN rpm-ostree install mesa-filesystem.i686 mesa-libEGL.i686 mesa-libGL.i686 mesa-libgbm.i686 mesa-vulkan-drivers.i686

RUN rpm-ostree install ffmpeg ffmpeg-libs libavdevice intel-media-driver pipewire-codec-aptx libva-intel-driver libva-utils nvidia-vaapi-driver

FROM base AS kernel

ARG KERNEL=kernel-cachyos-lto-skylake
ENV KERNEL=${KERNEL}

RUN cd /etc/yum.repos.d/ && wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-addons/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-addons-fedora-$(rpm -E %fedora).repo

RUN cd /etc/yum.repos.d/ && \
wget https://copr.fedorainfracloud.org/coprs/andersrh/kernel-cachyos/repo/fedora-$(rpm -E %fedora)/andersrh-kernel-cachyos-fedora-$(rpm -E %fedora).repo && \
wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-lto/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-lto-fedora-$(rpm -E %fedora).repo && \
wget https://negativo17.org/repos/fedora-nvidia.repo && \
cd /tmp

# install binutils to get strip command
RUN rpm-ostree install binutils

# Install Clang and Polly so kernel modules can be built
RUN rpm-ostree install clang polly

COPY install_cachyos_kernel.sh /tmp
# Enable cliwrap.
RUN rpm-ostree cliwrap install-to-root / && \
# Replace the kernel, kernel-core and kernel-modules packages.
/tmp/install_cachyos_kernel.sh ${KERNEL}

# install akmods
RUN ls /tmp/nvidia && /tmp/install-nvidia.sh ${KERNEL}
# Install Negativo17 Nvidia driver
RUN rpm-ostree install dkms-nvidia nvidia-driver ${KERNEL}-devel ${KERNEL}-devel-matched zstd
RUN sed -i -e 's/kernel-open$/kernel/g' /etc/nvidia/kernel.conf
RUN dkms install nvidia/$(ls /usr/src/ | grep nvidia- | cut -d- -f2-) -k $(rpm -q --queryformat "%{VERSION}-%{RELEASE}.%{ARCH}\n" ${KERNEL})

RUN rpm-ostree install nvidia-container-toolkit supergfxctl supergfxctl-plasmoid

RUN mv /etc/nvidia-container-runtime/config.toml{,.orig}

RUN systemctl enable supergfxd.service

# install Nvidia software
RUN rpm-ostree install nvidia-vaapi-driver nvidia-persistenced opencl-filesystem

# Clear cache, /var and /tmp and commit ostree
RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit


FROM kernel AS os

ARG CACHEBUST=5

RUN cd /tmp && \
rpm-ostree cleanup -m && rpm-ostree install ksshaskpass cronie distrobox fish lld nvtop seadrive-gui pulseaudio-utils hfsplus-tools VirtualBox

# Add podman-compose dependency for "podman compose" command
RUN rpm-ostree install podman-compose

# Disable SELinux
RUN sed -i "s/^SELINUX=.*$/SELINUX=permissive/g" /etc/sysconfig/selinux && sed -i "s/^SELINUX=.*$/SELINUX=permissive/g" /etc/selinux/config

# Xwayland clang
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:andersrh:my-ostree-os xorg-x11-server-Xwayland

# add Haruna media player to host for better VAAPI performance
RUN rpm-ostree install haruna

# Install AppImageLauncher
RUN rpm-ostree install https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm

# Install Gwenview on host for full support for image formats such as HEIC
RUN rpm-ostree install gwenview

# add cachyos-settings, scx-scheds and scx-manager
RUN rpm-ostree install scx-scheds scx-manager
RUN rpm-ostree override remove zram-generator-defaults --install cachyos-settings

# Install Waydroid
RUN rpm-ostree install waydroid

# Install virt-manager and LXC driver
RUN rpm-ostree install virt-manager libvirt-daemon-driver-lxc libvirt-daemon-lxc

# Install VDO tools and Bees
RUN rpm-ostree install vdo bees

# Install ZFS
RUN rpm -e --nodeps zfs-fuse && rpm-ostree install https://zfsonlinux.org/fedora/zfs-release-2-6$(rpm --eval "%{dist}").noarch.rpm && rpm-ostree install zfs --uninstall zfs-fuse

# Build ZFS module manually
RUN dkms install zfs/$(ls /usr/src/ | grep zfs- | cut -d- -f2-) -k $(rpm -q --queryformat "%{VERSION}-%{RELEASE}.%{ARCH}\n" ${KERNEL})

# Install Gnome Boxes
RUN rpm-ostree install gnome-boxes

# Remove plocate to avoid updatedb going crazy with scanning the file system once a day
RUN rpm-ostree override remove plocate

# enable scx service
RUN systemctl enable scx.service

# Copy config files
COPY etc /etc
# Copy /usr
COPY usr /usr

# Enable /nix mount service
RUN systemctl enable mount-nix-prepare.service
# Disable nvidia-powerd to avoid crashing when the system goes into suspension
RUN systemctl disable nvidia-powerd

# Clear cache, /var and /tmp and commit ostree
RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit
