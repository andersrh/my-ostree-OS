FROM ghcr.io/andersrh/my-ostree-os:main AS builder

RUN dnf install -y https://github.com/Alex313031/thorium/releases/download/M138.0.7204.300/thorium-browser_138.0.7204.300_AVX2.rpm

RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
bootc container lint
