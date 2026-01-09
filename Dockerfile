FROM ghcr.io/andersrh/my-ostree-os:main AS builder

RUN dnf install -y https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm

RUN rm -rf /tmp/* /var/* && mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
bootc container lint
