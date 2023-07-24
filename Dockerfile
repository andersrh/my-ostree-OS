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

# remove Okular and Firefox from base image
RUN rpm-ostree override remove firefox firefox-langpacks okular && \
rpm-ostree install ksshaskpass uksmd clang clang-devel cronie distrobox fish flatpak-builder gparted libcap-ng-devel libvirt-daemon-driver-lxc libvirt-daemon-lxc lld llvm nvtop procps-ng-devel seadrive-gui virt-manager waydroid && \
# install RPM-fusion
rpm-ostree install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
# install nonfree codecs
rpm-ostree override remove libavcodec-free libavfilter-free libavformat-free libavutil-free libpostproc-free libswresample-free libswscale-free mesa-va-drivers --install libavcodec-freeworld && \
rpm-ostree install ffmpeg ffmpeg-libs intel-media-driver pipewire-codec-aptx libva-intel-driver libva-utils mesa-va-drivers-freeworld && \
# install Pulseaudio utilities
rpm-ostree install pulseaudio-utils && \
# install Kata containers
rpm-ostree install kata-containers && \
# add bore-sysctl
rpm-ostree install bore-sysctl && \
# install Apple HFS+ tools
rpm-ostree install hfsplus-tools

RUN mkdir /var/opt && cd /tmp && wget https://mullvad.net/da/download/app/rpm/latest -O mullvad.rpm && rpm-ostree install mullvad.rpm && \
mv "/opt/Mullvad VPN" /usr/lib/opt/ && rm -f mullvad.rpm

# install gpu screen recorder
COPY gpu-screen-recorder/ /tmp/gpu-screen-recorder/
RUN cd /tmp/gpu-screen-recorder && \
./install.sh && \
setcap cap_sys_admin+ep '/usr/bin/gsr-kms-server'

# install gpu screen recorder gtk
COPY gpu-screen-recorder-gtk/ /tmp/gpu-screen-recorder-gtk/
RUN cd /tmp/gpu-screen-recorder-gtk && \
./install.sh

RUN rpm-ostree cleanup -m && \
rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit