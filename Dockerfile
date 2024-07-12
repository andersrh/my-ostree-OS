

FROM ghcr.io/andersrh/my-ostree-os:main-39 AS builder

RUN rpm-ostree install xorg-x11-drv-nvidia-power

# Clear cache, /var and /tmp and commit ostree
RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit
