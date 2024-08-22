

FROM ghcr.io/andersrh/my-ostree-os:main-39 AS builder

RUN rpm-ostree cleanup -m && rpm-ostree uninstall scx-scheds && rpm-ostree install scx-scheds-git

# Clear cache, /var and /tmp and commit ostree
RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit
