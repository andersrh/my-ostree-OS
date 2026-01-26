FROM quay.io/almalinuxorg/atomic-desktop-kde:10

COPY bin/set_next_version.sh /tmp
RUN /tmp/set_next_version.sh

COPY repo/*.repo /etc/yum.repos.d/
RUN dnf config-manager --add-repo=https://negativo17.org/repos/epel-nvidia-580.repo -y

RUN dnf install --nogpgcheck -y https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm

RUN dnf install -y fish distrobox nvtop intel-media-driver libva-intel-driver htop
RUN dnf install -y https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm

RUN dnf install -y $( \
                                                                              dnf list --available kernel\* --disablerepo='*' --enablerepo=my-ostree-os-rhel-epel,my-ostree-os-epel 2>/dev/null \
                                                                              | grep 'andersdsrhcustom' \
                                                                              | awk '{print $1 "-" $2}' \
                                                                              | sort -V \
                                                                              | tail -1 \
                                                                              | sed 's/\.src//g' \
                                                                              | sed 's/\.x86_64//g' \
                                                                  )

RUN dnf install -y waydroid scx-scheds

# Remove plocate to avoid updatedb going crazy with scanning the file system once a day
RUN dnf remove -y plocate

# Install Mullvad VPN client
RUN rpm -Uvh --nodeps https://mullvad.net/da/download/app/rpm/latest

# Install libheif-freeworld to show thumbnails in Dolphin
RUN dnf install libheif-freeworld -y

# Install proprietary codecs
RUN dnf swap libavcodec-free libavcodec-freeworld --allowerasing -y

RUN dnf -y install gwenview haruna kalk okular
RUN dnf -y install chromium
# Delete default Chromium config so it can be replaced by my own
RUN rm -f /etc/chromium/chromium.conf

# Add rule to SELinux allowing modules to be loaded into custom kernel
RUN setsebool -P domain_kernel_load_modules on

RUN dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
RUN dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

RUN dnf install firefox thunderbird -y

RUN rm -f /usr/lib64/libopenh264.so.2.4.1 /usr/lib64/libopenh264.so.7
RUN rpm -Uvh --nodeps https://codecs.fedoraproject.org/openh264/42/x86_64/Packages/o/openh264-2.5.1-1.fc42.x86_64.rpm https://codecs.fedoraproject.org/openh264/42/x86_64/Packages/m/mozilla-openh264-2.5.1-1.fc42.x86_64.rpm

# Install Thorium
RUN dnf install -y https://github.com/Alex313031/thorium/releases/download/M138.0.7204.300/thorium-browser_138.0.7204.300_AVX2.rpm

RUN dnf copr enable yselkowitz/xfce-epel -y
RUN dnf copr enable andersrh/xlibre-xserver -y
RUN dnf copr enable andersrh/xlibre-xserver-21 -y

RUN dnf install xlibre-xserver-Xorg xlibre-xserver-devel meson gcc cmake libX11-devel libXext-devel libXft-devel libXinerama-devel xorg-x11-proto-devel libxshmfence-devel libxkbfile-devel libbsd-devel libXfont2-devel xkbcomp libfontenc-devel libXres-devel libXdmcp-devel dbus-devel systemd-devel libudev-devel libxcvt-devel libdrm-devel libXv-devel libseat-devel libXv-devel xkbcomp xkeyboard-config-devel mesa-libGL-devel mesa-libEGL-devel libepoxy-devel mesa-libgbm-devel libdrm-devel xcb-util-devel  xcb-util-image-devel  xcb-util-keysyms-devel  xcb-util-wm-devel  xcb-util-renderutil-devel openssl-devel libXau-devel libXdmcp-devel libSM-devel libICE-devel startup-notification-devel libgtop2-devel libepoxy-devel libgudev-devel libwnck3-devel.x86_64 libdisplay-info-devel.x86_64 libnotify-devel.x86_64 upower-devel.x86_64 iceauth libICE-devel libSM-devel libXpresent-devel libyaml-devel vte291-devel gtk3-devel xorg-x11-xinit xlibre-xf86-input-libinput-devel xlibre-xf86-input-libinput -y

RUN mkdir /tmp/xfce
WORKDIR /tmp/xfce

ADD https://archive.xfce.org/xfce/4.20/fat_tarballs/xfce-4.20.tar.bz2 ./

RUN tar -xjf xfce-4.20.tar.bz2

WORKDIR /tmp/xfce/src

COPY buildinstallxfce.sh ./
RUN chmod +x buildinstallxfce.sh && ./buildinstallxfce.sh

RUN systemctl enable docker

COPY etc /etc
COPY usr /usr

RUN systemctl enable waydroid-choose-intel-gpu.service

RUN cd /usr/bin && wget https://raw.githubusercontent.com/CachyOS/CachyOS-Settings/refs/heads/master/usr/bin/kerver && chmod +x kerver

RUN cp -R /usr/etc/* /etc/

RUN rm -rf /tmp/* /var/* /usr/etc && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
bootc container lint
