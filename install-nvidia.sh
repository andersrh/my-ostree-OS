#!/bin/sh

KERNEL_VERSION="$(rpm -q $1 --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

rpm-ostree install /tmp/nvidia/*${KERNEL_VERSION}*.rpm
