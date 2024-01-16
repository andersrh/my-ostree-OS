ARG IMAGE_NAME="${IMAGE_NAME:-kinoite}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-kinoite}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"


FROM ghcr.io/andersrh/my-ostree-os-kernel-akmods:main-39 AS builder

ARG CACHEBUST=0
ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

RUN cd /tmp && \
rpm-ostree install ksshaskpass cronie distrobox fish flatpak-builder libcap-ng-devel libvirt-daemon-driver-lxc libvirt-daemon-lxc lld nvtop procps-ng-devel seadrive-gui virt-manager kerver pulseaudio-utils hfsplus-tools VirtualBox && \
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

# Add docker-compose dependency for "podman compose" command
RUN rpm-ostree install docker-compose

# Add docker -> podman alias for docker-compose to work properly
RUN ln -s /usr/bin/podman /usr/bin/docker

# Disable SELinux
RUN sed -i "s/^SELINUX=.*$/SELINUX=permissive/g" /etc/sysconfig/selinux && sed -i "s/^SELINUX=.*$/SELINUX=permissive/g" /etc/selinux/config

# pipewire clang
RUN cd /etc/yum.repos.d/ && wget https://copr.fedorainfracloud.org/coprs/trixieua/pipewire-clang/repo/fedora-$(rpm -E %fedora)/trixieua-pipewire-clang-fedora-$(rpm -E %fedora).repo && rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:trixieua:pipewire-clang pipewire pipewire-libs pipewire-pulseaudio pipewire-alsa pipewire-utils pipewire-gstreamer pipewire-jack-audio-connection-kit pipewire-jack-audio-connection-kit-libs

# Xwayland clang
RUN cd /etc/yum.repos.d/ && wget https://copr.fedorainfracloud.org/coprs/trixieua/Xwayland/repo/fedora-$(rpm -E %fedora)/trixieua-Xwayland-fedora-$(rpm -E %fedora).repo && rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:trixieua:Xwayland xorg-x11-server-Xwayland

# add Haruna media player to host for better VAAPI performance
RUN rpm-ostree install haruna

# software to be replaced with clang version
RUN rpm-ostree override replace --experimental --from repo=fedora-clang podman tar kpipewire NetworkManager-libnm NetworkManager NetworkManager-vpnc NetworkManager-wwan NetworkManager-wifi NetworkManager-ppp NetworkManager-bluetooth NetworkManager-config-connectivity-fedora wayland-utils xz xz-libs gzip bzip2-libs bzip2 libzip firefox firefox-langpacks libarchive rsync libva dbus-broker dbus-glib wget dbusmenu-qt

# Get latest Ledger Live AppImage
RUN wget https://download.live.ledger.com/latest/linux -O /usr/bin/ledgerlive && chmod +x /usr/bin/ledgerlive

# Install AppImageLauncher
RUN rpm-ostree install https://github.com/TheAssassin/AppImageLauncher/releases/download/continuous/appimagelauncher-2.2.0-gha111.d9d4c73.x86_64.rpm

# Install Gwenview and kimageformats for full support for image formats such as HEIC
RUN rpm-ostree install gwenview libheif-freeworld

# Copy config files
COPY etc /etc
# Copy /usr
COPY usr /usr

# Enable /nix mount service
RUN systemctl enable mount-nix-prepare.service

# Clear cache, /var and /tmp and commit ostree
RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit
