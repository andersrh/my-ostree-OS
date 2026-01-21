FROM quay.io/almalinuxorg/atomic-desktop-kde:10

RUN echo 'omit_drivers+=" nouveau "' | tee /etc/dracut.conf.d/blacklist-nouveau.conf

COPY bin/set_next_version.sh /tmp
RUN /tmp/set_next_version.sh

COPY repo/*.repo /etc/yum.repos.d/
RUN dnf config-manager --add-repo=https://negativo17.org/repos/epel-nvidia-580.repo -y

RUN dnf install -y $( \
                                                                              dnf list --available kernel\* --disablerepo='*' --enablerepo=my-ostree-os-rhel-epel,my-ostree-os-epel 2>/dev/null \
                                                                              | grep 'andersdsrhcustom' \
                                                                              | awk '{print $1 "-" $2}' \
                                                                              | sort -V \
                                                                              | tail -1 \
                                                                              | sed 's/\.src//g' \
                                                                              | sed 's/\.x86_64//g' \
                                                                  )

RUN dnf install --nogpgcheck -y https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm

RUN dnf install -y fish distrobox nvtop intel-media-driver libva-intel-driver htop
RUN dnf install -y https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm

# Install Negativo17 Nvidia driver
RUN dnf install -y dkms-nvidia nvidia-driver nvidia-persistenced opencl-filesystem libva-nvidia-driver kernel-devel-matched
RUN dkms install nvidia/$(ls /usr/src/ | grep nvidia- | cut -d- -f2-) -k $(rpm -q --queryformat "%{VERSION}-%{RELEASE}.%{ARCH}\n" kernel)

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

RUN systemctl enable docker

COPY etc /etc
COPY usr /usr

RUN systemctl enable waydroid-choose-intel-gpu.service

RUN cd /usr/bin && wget https://raw.githubusercontent.com/CachyOS/CachyOS-Settings/refs/heads/master/usr/bin/kerver && chmod +x kerver

RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
bootc container lint
