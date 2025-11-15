FROM quay.io/almalinuxorg/atomic-desktop-kde:10
ARG CACHEBUST=1
# Get list of kernels from my repo. If the list has been updated, then the image will be rebuilt. If it hasn't been updated, then caching of the previous build will be used.
ADD "https://copr.fedorainfracloud.org/api_3/build/list?ownername=andersrh&projectname=my-ostree-os&packagename=kernel" /tmp/builds.txt

RUN echo 'omit_drivers+=" nouveau "' | tee /etc/dracut.conf.d/blacklist-nouveau.conf

COPY repo/*.repo /etc/yum.repos.d/
RUN dnf config-manager --add-repo=https://negativo17.org/repos/epel-nvidia.repo -y

RUN dnf install -y $( \
                                                                              dnf list --available kernel\* --disablerepo='*' --enablerepo=my-ostree-os-rhel-epel 2>/dev/null \
                                                                              | grep 'andersdsrhcustom' \
                                                                              | awk '{print $1 "-" $2}' \
                                                                              | sort -V \
                                                                              | tail -1 \
                                                                              | sed 's/\.src//g' \
                                                                  )

RUN dnf install --nogpgcheck -y https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm

RUN dnf install -y fish distrobox nvtop intel-media-driver libva-intel-driver
RUN dnf install -y https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm

# Install Negativo17 Nvidia driver
RUN dnf install -y dkms-nvidia nvidia-driver nvidia-persistenced opencl-filesystem libva-nvidia-driver
RUN sed -i -e 's/kernel-open$/kernel/g' /etc/nvidia/kernel.conf
RUN dkms install nvidia/$(ls /usr/src/ | grep nvidia- | cut -d- -f2-) -k $(rpm -q --queryformat "%{VERSION}-%{RELEASE}.%{ARCH}\n" ${KERNEL})

RUN dnf install -y waydroid scx-scheds

# Remove plocate to avoid updatedb going crazy with scanning the file system once a day
RUN dnf remove -y plocate

# Install Mullvad VPN client
RUN rpm -Uvh --nodeps https://mullvad.net/da/download/app/rpm/latest

# Install libheif-freeworld to show thumbnails in Dolphin
RUN dnf install libheif-freeworld -y

# Install proprietary codecs
RUN dnf swap libavcodec-free libavcodec-freeworld --allowerasing -y

# Add rule to SELinux allowing modules to be loaded into custom kernel
RUN setsebool -P domain_kernel_load_modules on

COPY etc /etc
COPY usr /usr

RUN systemctl enable waydroid-choose-intel-gpu.service

RUN cd /usr/bin && wget https://raw.githubusercontent.com/CachyOS/CachyOS-Settings/refs/heads/master/usr/bin/kerver && chmod +x kerver

RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
bootc container lint
