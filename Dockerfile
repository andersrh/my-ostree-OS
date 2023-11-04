ARG IMAGE_NAME="${IMAGE_NAME:-kinoite}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-kinoite}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"


FROM ghcr.io/andersrh/my-ostree-os-kernel-akmods:main-38 AS builder

ARG CACHEBUST=0
ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

RUN rpm-ostree install kerver

RUN cd /tmp && \
# remove Okular and Firefox from base image
rpm-ostree override remove firefox firefox-langpacks okular okular-libs okular-part mozilla-openh264 && \
rpm-ostree install ksshaskpass cronie distrobox fish flatpak-builder gparted libcap-ng-devel libvirt-daemon-driver-lxc libvirt-daemon-lxc lld nvtop procps-ng-devel seadrive-gui virt-manager waydroid && \
# install Pulseaudio utilities
rpm-ostree install pulseaudio-utils && \
# install Apple HFS+ tools
rpm-ostree install hfsplus-tools && \
# install Mullvad VPN
mkdir /var/opt && rpm-ostree install https://mullvad.net/da/download/app/rpm/latest && \
mv "/opt/Mullvad VPN" /usr/lib/opt/ && \
# enable automatic updates
sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
# change auto update interval
sed -i 's/OnUnitInactiveSec.*/OnUnitInactiveSec=1h\nOnCalendar=*-*-* 06:40:00\nPersistent=true/' /usr/lib/systemd/system/rpm-ostreed-automatic.timer

# Install TeamViewer
RUN rpm-ostree install https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm && \
mv "/opt/teamviewer" /usr/lib/opt/
# Disable Teamviewerd by default
RUN systemctl disable teamviewerd
RUN systemctl enable rpm-ostreed-automatic.timer

# Change ZRAM max to 16GB
RUN sed -i 's/zram-size.*/zram-size = min(ram, 16384)/' /usr/lib/systemd/zram-generator.conf

# Copy config files
COPY etc /etc
# Copy /usr
COPY usr /usr

# Clear cache, /var and /tmp and commit ostree
RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit

FROM builder AS builder2


# Install VirtualBox
RUN rpm-ostree install VirtualBox

# Clear cache, /var and /tmp and commit ostree
RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit
