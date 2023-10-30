ARG IMAGE_NAME="${IMAGE_NAME:-kinoite}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-kinoite}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"
 
FROM ghcr.io/andersrh/my-ostree-os-kernel-akmods:main-38 AS builder

ARG CACHEBUST=1

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"


# 32-bit dependencies for the Nvidia driver.
#RUN rpm-ostree install glibc.i686 mesa-dri-drivers.i686 mesa-filesystem.i686 mesa-libEGL.i686 mesa-libGL.i686 mesa-libgbm.i686 mesa-libglapi.i686 mesa-vulkan-drivers.i686
# install nonfree codecs
RUN rpm-ostree override remove libavcodec-free libavfilter-free libavformat-free libavutil-free libpostproc-free libswresample-free libswscale-free mesa-va-drivers --install libavcodec-freeworld
RUN mv /etc/yum.repos.d/rpmfusion-free.repo /tmp/rpmfusion-free.repo && rpm-ostree install mesa-va-drivers-freeworld && mv /tmp/rpmfusion-free.repo /etc/yum.repos.d/rpmfusion-free.repo
RUN rpm-ostree install ffmpeg ffmpeg-libs intel-media-driver pipewire-codec-aptx libva-intel-driver libva-utils

# install Nvidia software
RUN rpm-ostree install nvidia-vaapi-driver nvidia-persistenced opencl-filesystem
