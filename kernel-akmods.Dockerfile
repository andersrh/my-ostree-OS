ARG IMAGE_NAME="${IMAGE_NAME:-kinoite}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-kinoite}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"

FROM fedora:39 AS akmods-builder

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

FROM ghcr.io/andersrh/my-ostree-os-base2:main-39 AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

COPY --from=ghcr.io/ublue-os/akmods-nvidia:39-535 /rpms /tmp/akmods-rpms

RUN rpm-ostree install \
    /tmp/akmods-rpms/ublue-os/ublue-os-nvidia-addons-*.rpm

RUN mkdir /tmp/nvidia

COPY install-nvidia.sh /tmp/install-nvidia.sh

RUN cd /etc/yum.repos.d/ && wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-addons/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-addons-fedora-$(rpm -E %fedora).repo

RUN cd /etc/yum.repos.d/ && \
wget https://copr.fedorainfracloud.org/coprs/andersrh/kernel-cachyos/repo/fedora-$(rpm -E %fedora)/andersrh-kernel-cachyos-fedora-$(rpm -E %fedora).repo && \
wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-lto/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-lto-fedora-$(rpm -E %fedora).repo && \
cd /tmp

# add bore-sysctl, uksmd and scx-scheds
RUN rpm-ostree install bore-sysctl uksmd scx-scheds libcap-ng-devel procps-ng-devel

# override and upgrade libbpf
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons libbpf

# enable systemd services

RUN systemctl enable uksmd.service
RUN systemctl enable scx.service

COPY --from=akmods-builder /var/cache/akmods/*/* /tmp/nvidia

# Enable cliwrap.
RUN rpm-ostree cliwrap install-to-root / && \
# Replace the kernel, kernel-core and kernel-modules packages.
rpm-ostree override remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra --install kernel-cachyos-lto

# install kernel headers
RUN rpm-ostree install kernel-cachyos-lto-headers

# install akmods
RUN ls /tmp/nvidia && /tmp/install-nvidia.sh

RUN rpm-ostree install \
    xorg-x11-drv-nvidia{,-cuda,-devel,-kmodsrc} \
    xorg-x11-drv-nvidia-libs.i686 \
    nvidia-container-toolkit supergfxctl supergfxctl-plasmoid

RUN mv /etc/nvidia-container-runtime/config.toml{,.orig}
RUN cp /etc/nvidia-container-runtime/config{-rootless,}.toml

RUN systemctl enable supergfxd.service

RUN rpm-ostree uninstall xorg-x11-drv-nvidia-power

RUN semodule --verbose --install /usr/share/selinux/packages/nvidia-container.pp
RUN ln -s /usr/bin/ld.bfd /etc/alternatives/ld
RUN ln -s /etc/alternatives/ld /usr/bin/ld

# install Nvidia software
RUN rpm-ostree install nvidia-vaapi-driver nvidia-persistenced opencl-filesystem

# Clear cache, /var and /tmp and commit ostree
RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit
