#!/bin/sh


qemu-system-x86_64 -hda /home/xun/Workspace/qemu_conf/qemu_img/openEuler.qcow2 -m 5G \
  -drive if=pflash,readonly=on,file=/home/xun/Workspace/qemu_conf/QEMU_EFI.fd \
  -drive if=pflsh,file=/home/xun/Workspace/qemu_conf/QEMU_VARS.fd \
  -cdrom iso/openEuler-22.03-LTS-x86_64-dvd.iso \
  -net user,hostfwd=tcp::2224-:22 \
  -net nic \
  -nographic \
  > /home/xun/Workspace/qemu_conf/log/openEuler.log 2>&1 &
