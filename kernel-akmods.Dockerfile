FROM fedora:40 AS akmods-builder

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

FROM scratch

COPY --from=akmods-builder /var/cache/akmods/*/* /
