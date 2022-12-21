#!/bin/sh

get_path() {
  rev | cut -d ' ' -f1 | tr -d . | rev
}

echo "Creating loop device for vault"
LOOP="$(udisksctl loop-setup --no-user-interaction -f $HOME/Sync/.vault.img | get_path)"
echo "Unlocking loop device"
UNLOCK="$(udisksctl unlock -b $LOOP | get_path)"
echo "Mounting unlocked device"
MOUNT="$(udisksctl mount --no-user-interaction -b $UNLOCK | get_path)"

ranger "$MOUNT"

echo "Unmounting unlocked device"
udisksctl unmount -b $UNLOCK 1>/dev/null
echo "Locking loop device"
udisksctl lock -b $LOOP 1>/dev/null
echo "Removing loop device"
udisksctl loop-delete -b $LOOP

echo "Show existing loop devices"
lsblk $(ls -1 /dev/loop* | grep -v loop-control)
