

FROM ghcr.io/andersrh/my-ostree-os:main AS builder

RUN rpm-ostree cleanup -m && rpm-ostree install virt-manager libvirt-daemon-driver-lxc libvirt-daemon-lxc

# Clear cache, /var and /tmp and commit ostree
RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit
