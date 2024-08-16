#!/bin/bash

PACKAGE_NAME="kernel-headers"

if rpm -q $PACKAGE_NAME &> /dev/null; then
    echo "Package '$PACKAGE_NAME' is installed."
else
    echo "Package '$PACKAGE_NAME' is not installed."
    PACKAGE_NAME=""
fi

rpm-ostree override remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra $PACKAGE_NAME --install kernel-cachyos-lto
