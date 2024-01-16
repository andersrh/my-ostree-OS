ARG IMAGE_NAME="${IMAGE_NAME:-kinoite}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-kinoite}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"
 

FROM quay.io/fedora-ostree-desktops/kinoite:39 AS builder

ARG CACHEBUST=2

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"


COPY repo/*.repo /etc/yum.repos.d/

# install RPM-fusion
RUN rpm-ostree install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# 32-bit dependencies for the Nvidia driver.
RUN rpm-ostree install glibc.i686

# install nonfree codecs
RUN rpm-ostree override remove libavcodec-free libavfilter-free libavformat-free libavutil-free libpostproc-free libswresample-free libswscale-free --install libavcodec-freeworld

# Install HEIC support for Gwenview and Dolphin (and potentially other applications)
RUN rpm-ostree install libheif-freeworld

# Mesa clang
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:trixieua:mesa-clang mesa-filesystem mesa-libglapi mesa-dri-drivers mesa-libgbm mesa-libEGL mesa-libGL mesa-vulkan-drivers mesa-libxatracker mesa-vdpau-drivers mesa-libOSMesa mesa-libOpenCL mesa-va-drivers

# 32-bit dependencies for the Nvidia driver.
RUN rpm-ostree override replace --experimental --from repo=mesa-clang-i386 mesa-dri-drivers.i686
RUN rpm-ostree install mesa-filesystem.i686 mesa-libEGL.i686 mesa-libGL.i686 mesa-libgbm.i686 mesa-libglapi.i686 mesa-vulkan-drivers.i686

RUN rpm-ostree install ffmpeg ffmpeg-libs intel-media-driver pipewire-codec-aptx libva-intel-driver libva-utils
