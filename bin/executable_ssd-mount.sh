#!/bin/sh

echo 'Please input the LUKS passphrase:'
udisksctl unlock -b /dev/disk/by-partlabel/SSDCrypt
udisksctl mount -b /dev/disk/by-label/SSDData
udisksctl mount -b /dev/disk/by-label/SSDCrypt
yazi
udisksctl unmount -b /dev/disk/by-label/SSDData
udisksctl unmount -b /dev/disk/by-label/SSDCrypt
udisksctl lock -b /dev/disk/by-partlabel/SSDCrypt

