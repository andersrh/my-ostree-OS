#!/bin/sh

APPNAME="ledgerlive"

podman build -t andersrh/fedora-toolbox/$APPNAME -f Dockerfile .
podman rm -f $APPNAME
distrobox create --image andersrh/fedora-toolbox/$APPNAME --home ~/containers/$APPNAME/ $APPNAME
distrobox enter $APPNAME -- distrobox-export --bin /app/$APPNAME --export-path ~/.local/bin --extra-flags "--enable-features=WaylandWindowDecorations --ozone-platform=wayland"

podman rm -f $APPNAME

podman create --hostname "ledgerlive.anders-fedora" --ipc host --name "ledgerlive" --network host --privileged --security-opt label=disable --user root:root --pid host --label "manager=distrobox" --env "SHELL=/bin/bash" --env "HOME=/var/home/anders" --volume /:/run/host:rslave --volume /dev:/dev:rslave --volume /sys:/sys:rslave --volume /tmp:/tmp:rslave --volume "/usr/bin/distrobox-init":/usr/bin/entrypoint:ro --volume "/usr/bin/distrobox-export":/usr/bin/distrobox-export:ro --volume "/usr/bin/distrobox-host-exec":/usr/bin/distrobox-host-exec:ro --volume "/var/home/anders/containers/$APPNAME":"/var/home/anders":rslave --volume /sys/fs/selinux --volume /var/log/journal --volume /run/user/1000:/run/user/1000:rslave --volume /etc/hosts:/etc/hosts:ro --volume /etc/localtime:/etc/localtime:ro --volume /etc/resolv.conf:/etc/resolv.conf:ro --ulimit host --annotation run.oci.keep_original_groups=1 --mount type=devpts,destination=/dev/pts --userns keep-id --entrypoint /usr/bin/entrypoint andersrh/fedora-toolbox/ledgerlive -v --name "anders" --user 1000 --group 1000 --home "/var/home/anders" --init "0" --pre-init-hooks "" -- ''

cp ledgerlive.png ~/.local/share/icons/
cp ledgerlive.desktop ~/.local/share/applications/
