#!/bin/sh

KERNEL_VERSION="$(rpm -q kernel-cachyos-bore-eevdf --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

akmods --force --kernels "${KERNEL_VERSION}"
