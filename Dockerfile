

FROM ghcr.io/andersrh/my-ostree-os:main-39 AS builder

COPY *.rpm /tmp

RUN rpm-ostree install /tmp/sched-ext-scx-0.1.10-3.fc39.x86_64.rpm
