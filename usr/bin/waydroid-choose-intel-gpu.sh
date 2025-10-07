#!/bin/bash

lspci="$(lspci -nn | grep '\[03')" # https://pci-ids.ucw.cz/read/PD/03

echo "Searching for Intel GPU..."
gpus=()
while IFS= read lspci; do
	gpus+=("$lspci")
done < <(echo "$lspci")

# Automatically find and select Intel GPU
gpuchoice=""
for gpu in "${gpus[@]}"; do
	if [[ "$gpu" == *"Intel"* ]]; then
		gpuchoice="${gpu%% *}" # e.g. "26:00.0"
		echo "Found Intel GPU: $gpu"
		break
	fi
done

if [ -z "$gpuchoice" ]; then
	echo "Error: No Intel GPU found!"
	echo "Available GPUs:"
	for i in "${!gpus[@]}"; do
		echo "  $((i+1)). ${gpus[i]}"
	done
	exit 1
fi

echo ""
echo "Confirm that these belong to your GPU:"
echo ""

ls -l /dev/dri/by-path/ | grep -i $gpuchoice

echo ""

card=$(ls -l /dev/dri/by-path/ | grep -i $gpuchoice | grep -o "card[0-9]")
rendernode=$(ls -l /dev/dri/by-path/ | grep -i $gpuchoice | grep -o "renderD[1-9][1-9][1-9]")

echo /dev/dri/$card
echo /dev/dri/$rendernode

cp /var/lib/waydroid/lxc/waydroid/config_nodes /var/lib/waydroid/lxc/waydroid/config_nodes.bak
#lxc.mount.entry = /dev/dri dev/dri none bind,create=dir,optional 0 0
sed -i '/dri/d' /var/lib/waydroid/lxc/waydroid/config_nodes
echo "lxc.mount.entry = /dev/dri/$card dev/dri/card0 none bind,create=file,optional 0 0" >> /var/lib/waydroid/lxc/waydroid/config_nodes
echo "lxc.mount.entry = /dev/dri/$rendernode dev/dri/renderD128 none bind,create=file,optional 0 0" >> /var/lib/waydroid/lxc/waydroid/config_nodes
