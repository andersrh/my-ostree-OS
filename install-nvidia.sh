#!/bin/sh

KERNEL_VERSION="$(rpm -q $1 --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

if ls /tmp/nvidia/*.failed.log >/dev/null 2>&1; then
    cat /tmp/nvidia/*.failed.log
else
    echo "No error files present. Akmods modules were built successfully."
fi

rpm-ostree install /tmp/nvidia/*${KERNEL_VERSION}*.rpm
