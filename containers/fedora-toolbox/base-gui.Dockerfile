FROM registry.fedoraproject.org/fedora-toolbox:38

RUN dnf update -y
RUN dnf install -y fish htop nano firejail
RUN dnf install -y libnotify nss
RUN dnf install -y --allowerasing bash bc curl diffutils dnf-plugins-core findutils gnupg2 less lsof ncurses passwd pinentry procps-ng shadow-utils sudo time util-linux wget vte-profile
RUN dnf install -y at-spi2-core gtk3 libXScrnSaver libXtst xdg-utils
RUN dnf install -y libglvnd-gles
RUN dnf install -y mesa-dri-drivers mesa-vulkan-drivers vulkan
RUN dnf install -y libva ibus ibus-gtk3 ibus-libs ibus-m17n ibus-setup libmpc libxkbcommon-x11 libxkbfile m17n-db m17n-lib python3-cairo python3-gobject python3-gobject-base python3-gobject-base-noarch setxkbmap xcb-util xcb-util-image xcb-util-keysyms xcb-util-renderutil xcb-util-wm xhost xmodmap xorg-x11-xinit xrdb cpp
RUN dnf install -y gcr3-base gcr3 gnome-keyring
RUN dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
&& dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
RUN dnf install -y libva-intel-driver gstreamer1-plugin-openh264 ffmpeg libva-utils libavcodec-freeworld nvidia-vaapi-driver nvidia-persistenced opencl-filesystem
RUN dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
RUN dnf install -y \
    xorg-x11-drv-nvidia{,-cuda,-devel,-kmodsrc} \
    xorg-x11-drv-nvidia-libs.i686
RUN dnf install -y dbus-glib pciutils-libs
RUN dnf -y install fuse
RUN dnf install -y firefox
