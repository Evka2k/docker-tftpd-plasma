#!/bin/sh
echo "Downloading archlinux ..."
wget http://mirrors.atviras.lt/archlinux/iso/latest/arch/boot/x86_64/vmlinuz-linux -O ./archlinux/vmlinuz-linux
wget http://mirrors.atviras.lt/archlinux/iso/latest/arch/boot/x86_64/initramfs-linux.img -O ./archlinux/initramfs-linux.img
wget http://mirrors.atviras.lt/archlinux/iso/latest/arch/boot/amd-ucode.img -O ./archlinux/amd-ucode.img
wget http://mirrors.atviras.lt/archlinux/iso/latest/arch/boot/intel-ucode.img -O ./archlinux/intel-ucode.img
echo "Done."
