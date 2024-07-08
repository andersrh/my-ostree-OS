

FROM ghcr.io/andersrh/my-ostree-os:main-39 AS builder

COPY *.rpm /tmp

RUN rpm-ostree uninstall sched-ext-scx && rpm-ostree install /tmp/sched-ext-scx-0.1.10-3.fc39.x86_64.rpm

# Clear cache, /var and /tmp and commit ostree
RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
ostree container commit
