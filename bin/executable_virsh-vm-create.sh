#!/bin/sh

if [ $# -eq 0 ]; then
  echo "Usage:"
  echo $(basename $0)" NAME OS [MEMORY]"
  exit 1
elif [ $# -eq 2 ]; then
  VMNAME=$1
  OS=$2
  MEMORY=1024
elif [ $# -eq 3 ]; then
  VMNAME=$1
  OS=$2
  MEMORY=$3
else
  echo "Wrong number of parameters given, stopping..."
  exit 1
fi

clear

if [ "$OS" == "windows" ]; then
  sudo virt-install --name $VMNAME \
                    --accelerate \
                    --hvm \
                    --connect qemu:///system \
                    --network network:default,model=virtio \
                    --ram=$MEMORY \
                    --os-type=windows \
                    --os-variant=win7 \
                    --disk pool=disks,format=qcow2,bus=virtio,cache=none,size=15 \
                    --disk device=cdrom,vol=cdrom/windows_8.1.iso \
                    --disk device=cdrom,vol=cdrom/virtio-win-0.1-74.iso \
                    --soundhw ac97 \
                    --graphics spice \
                    --video qxl
elif [ "$OS" == "centos" ]; then
  sudo virt-install --name $VMNAME \
                    --accelerate \
                    --hvm \
                    --connect qemu:///system \
                    --network network:default,model=virtio \
                    --ram=$MEMORY \
                    --os-type=linux \
                    --os-variant=rhel6 \
                    --disk pool=disks,format=qcow2,bus=virtio,cache=none,size=15 \
                    --location "http://ftp.nluug.nl/os/Linux/distr/CentOS/6.5/os/x86_64" \
                    --extra-args "console=ttyS0,115200" \
                    --graphics none
elif [ "$OS" == "centosks" ]; then
  sudo virt-install --name $VMNAME \
                    --accelerate \
                    --hvm \
                    --connect qemu:///system \
                    --network network:default,model=virtio \
                    --ram=$MEMORY \
                    --os-type=linux \
                    --os-variant=rhel6 \
                    --disk pool=disks,format=qcow2,bus=virtio,cache=none,size=15 \
                    --location "http://ftp.nluug.nl/os/Linux/distr/CentOS/6.5/os/x86_64" \
                    --extra-args "ks=http://www.mdekort.lan/ks/centos6minimal.cfg console=ttyS0,115200" \
                    --graphics none
elif [ "$OS" == "pxe" ]; then
  sudo virt-install --name $VMNAME \
                    --accelerate \
                    --hvm \
                    --connect qemu:///system \
                    --network network:default,model=virtio \
                    --ram=$MEMORY \
                    --os-type=linux \
                    --os-variant=generic26 \
                    --disk pool=disks,format=qcow2,bus=virtio,cache=none,size=15 \
                    --pxe \
                    --graphics vnc,listen=0.0.0.0 \
                    --video qxl
else
  echo "This is an unknown OS, stopping..."
  exit 1
fi

