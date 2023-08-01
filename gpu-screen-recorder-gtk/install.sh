#!/bin/sh -e

script_dir=$(dirname "$0")
cd "$script_dir"

[ $(id -u) -ne 0 ] && echo "You need root privileges to run the install script" && exit 1

#./build.sh

install -Dm755 "gpu-screen-recorder-gtk" "/usr/bin/gpu-screen-recorder-gtk"
install -Dm644 "gpu-screen-recorder-gtk.desktop" "/usr/share/applications/com.dec05eba.gpu_screen_recorder.desktop"
install -Dm644 com.dec05eba.gpu_screen_recorder.appdata.xml "/usr/share/metainfo/com.dec05eba.gpu_screen_recorder.appdata.xml"
install -Dm644 icons/hicolor/64x64/apps/com.dec05eba.gpu_screen_recorder.png "/usr/share/icons/hicolor/64x64/apps/com.dec05eba.gpu_screen_recorder.png"
install -Dm644 icons/hicolor/128x128/apps/com.dec05eba.gpu_screen_recorder.png "/usr/share/icons/hicolor/128x128/apps/com.dec05eba.gpu_screen_recorder.png"

echo "Successfully installed gpu-screen-recorder-gtk"
