#!/bin/sh

qemu-system-x86_64 -hda /home/xun/Workspace/qemu/nixos.qcow2 -m 4G -cdrom /home/xun/Workspace/qemu_conf/iso/nixos-minimal-22.11.4426.c8a17ce7abc-x86_64-linux.iso -boot c \
  -drive if=pflash,readonly=on,file=/usr/share/edk2-ovmf/x64/OVMF_CODE.fd \
  -drive if=pflash,file=/home/xun/Workspace/qemu_conf/drive/OVMF_VARS.fd \
  -net user,hostfwd=tcp::2222-:22 \
  -net nic \
  > /home/xun/Workspace/qemu_conf/log/nixos.log 2>&1 &
