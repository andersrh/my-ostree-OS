#!/bin/sh

KERNEL=$1

KERNEL_VERSION="$(rpm -q $KERNEL --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

akmods --force --kernels "${KERNEL_VERSION}"
