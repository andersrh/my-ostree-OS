#!/bin/sh

KERNEL_VERSION="$(rpm -q kernel-cachyos-lts-lto-v3 --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

akmods --force --kernels "${KERNEL_VERSION}"
