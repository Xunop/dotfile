#!/bin/sh

img_path=/home/xun/Workspace/qemu_conf/qemu_img/WindowsVM.img
iso=/home/xun/Workspace/qemu_conf/iso/cn_windows_10_multi-edition_vl_version_1709_updated_dec_2017_x64_dvd_100406208.iso
vi_iso=/home/xun/Workspace/qemu_conf/iso/virtio-win-0.1.229.iso

qemu-system-x86_64 -drive file=$img_path,format=qcow2,if=virtio \
  -drive file=$iso,media=cdrom \
  -drive file=$vi_iso,media=cdrom \
  -boot order=d \
  -audiodev pa,id=pa1 \
  -device ich9-intel-hda,id=sound0,bus=pcie.0,addr=0x1b \
  -device hda-duplex,id=sound0-codec0,bus=sound0.0,cad=0 \
  -global ICH9-LPC.disable_s3=1 -global ICH9-LPC.disable_s4=1 \
  -device qemu-xhci \
  -device usb-tablet \
  -enable-kvm \
  -machine type=q35 \
  -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_time,hv_vapic,hv_vendor_id=0xDEADBEEFFF \
  -rtc clock=host,base=localtime \
  -m 8G \
  -smp sockets=1,cores=6,threads=1 \
  -net nic, -net user,hostname=windows \
  -vga virtio \
  -display sdl,gl=on -name "Windows 10 1709 64 bit" > /home/xun/Workspace/qemu_conf/log/windows.log 2>&1 &

#-monitor stdio \
