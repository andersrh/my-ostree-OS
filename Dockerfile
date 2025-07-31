FROM quay.io/almalinuxorg/atomic-desktop-kde:latest


ARG KERNEL=kernel-cachyos-lto-skylake
ENV KERNEL=${KERNEL}

# Get list of kernels from my repo. If the list has been updated, then the image will be rebuilt. If it hasn't been updated, then caching of the previous build will be used.
ADD "https://copr.fedorainfracloud.org/api_3/build/list?ownername=andersrh&projectname=my-ostree-os&packagename=kernel-cachyos-lto-skylake" /tmp/builds.txt

RUN dnf upgrade -y

RUN dnf copr enable -y andersrh/my-ostree-os

RUN dnf install --nogpgcheck -y https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm

RUN dnf config-manager --add-repo=https://negativo17.org/repos/epel-nvidia.repo -y 

RUN dnf install -y fish distrobox nvtop gwenview intel-media-driver libva-intel-driver
RUN dnf install -y https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm

RUN dnf install -y ${KERNEL} ${KERNEL}-devel-matched

RUN dnf remove -y kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs

# Install Negativo17 Nvidia driver
RUN dnf install -y dkms-nvidia nvidia-driver nvidia-persistenced opencl-filesystem libva-nvidia-driver
RUN sed -i -e 's/kernel-open$/kernel/g' /etc/nvidia/kernel.conf
RUN dkms install nvidia/$(ls /usr/src/ | grep nvidia- | cut -d- -f2-) -k $(rpm -q --queryformat "%{VERSION}-%{RELEASE}.%{ARCH}\n" ${KERNEL})
RUN echo 'omit_drivers+=" nouveau "' | tee /etc/dracut.conf.d/blacklist-nouveau.conf
RUN dracut --regenerate-all --force
RUN depmod -a

# Allow connections to KDEConnect
RUN firewall-cmd --permanent --zone=public --add-service=kdeconnect

RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
bootc container lint
