#!/usr/bin/env bash
DEVICE="$1"
MOUNT_POINT="/mnt/usb/$DEVICE"

mkdir -p "$MOUNT_POINT" || exit 1
mount -o gid=storage,umask=002 "/dev/$DEVICE" "$MOUNT_POINT" || exit 1
chown :storage "$MOUNT_POINT" 2>/dev/null || true

/usr/local/bin/notify-all-users.sh "Flash disk mounted" "Device successfully mounted to $MOUNT_POINT"
