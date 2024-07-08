

FROM ghcr.io/andersrh/my-ostree-os:main-39 AS builder

RUN rpm-ostree install sched-ext-scx-0.1.10-3.fc39.x86_64.rpm
