#!/bin/sh

KERNEL_VERSION="$(rpm -q kernel-cachyos-lts --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

akmods --force --kernels "${KERNEL_VERSION}"
