FROM quay.io/almalinuxorg/atomic-desktop-kde:10


ARG KERNEL=kernel-cachyos-lto-skylake-test
ENV KERNEL=${KERNEL}

# Get list of kernels from my repo. If the list has been updated, then the image will be rebuilt. If it hasn't been updated, then caching of the previous build will be used.
ADD "https://copr.fedorainfracloud.org/api_3/build/list?ownername=andersrh&projectname=my-ostree-os&packagename=kernel-cachyos-lto-skylake-test" /tmp/builds.txt

COPY repo/*.repo /etc/yum.repos.d/

RUN dnf install -y ${KERNEL} ${KERNEL}-devel-matched

RUN dnf remove -y kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs

RUN dnf upgrade -y

RUN dnf install --nogpgcheck -y https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm

RUN dnf install -y fish distrobox nvtop intel-media-driver libva-intel-driver
RUN dnf install -y https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm

RUN dnf install -y waydroid scx-scheds

# Remove plocate to avoid updatedb going crazy with scanning the file system once a day
RUN dnf remove -y plocate

# Install Mullvad VPN client
RUN rpm -Uvh --nodeps https://mullvad.net/da/download/app/rpm/latest

# Install Portmaster
RUN dnf install -y https://updates.safing.io/latest/linux_amd64/packages/Portmaster-2.0.25-1.x86_64.rpm

# Add rule to SELinux allowing modules to be loaded into custom kernel
RUN setsebool -P domain_kernel_load_modules on

COPY etc/environment /etc/environment
COPY etc/systemd/zram-generator.conf /etc/systemd/zram-generator.conf

RUN cd /usr/bin && wget https://raw.githubusercontent.com/CachyOS/CachyOS-Settings/refs/heads/master/usr/bin/kerver && chmod +x kerver

RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
bootc container lint
