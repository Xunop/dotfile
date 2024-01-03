#!/bin/sh

#
qemu-system-x86_64 -hda /home/xun/Workspace/qemu_conf/qemu_img/arch.qcow2 -m 4G \
  -cdrom /home/xun/Workspace/qemu_conf/iso/archlinux-2023.05.03-x86_64.iso -boot c \
  -drive if=pflash,readonly=on,file=/usr/share/edk2-ovmf/x64/OVMF_CODE.fd \
  -drive if=pflash,file=/home/xun/Workspace/qemu_conf/drive/OVMF_VARS.fd \
  -net user,hostfwd=tcp::2222-:22 \
  -net nic \
  --trace "memory_region_ops_*" \
  -monitor stdio
