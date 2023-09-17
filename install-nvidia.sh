#!/bin/sh

KERNEL_VERSION="$(rpm -q kernel-cachyos-lts --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

rpm-ostree install /tmp/nvidia/*${KERNEL_VERSION}*.rpm
