#!/bin/sh

if [ $# -ne 1 ]
then
  echo "Invalid amount of parameters given, stopping..."
  exit 1
fi

sudo virsh destroy $1
sudo virsh undefine $1
sudo virsh vol-delete --pool disks ${1}.img

