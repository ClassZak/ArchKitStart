#!/usr/bin/env bash
DEVICE="$1"
MOUNT_POINT="/mnt/usb/$DEVICE"
DEVICE_PATH="/dev/$DEVICE"

if [ ! -b "$DEVICE_PATH" ]; then
	echo "Device $DEVICE_PATH not found" >&2
	/usr/local/bin/notify-all-users.sh "Flash disk not mounted" "Device path $DEVICE_PATH not fount"
	exit 1
fi

FSTYPE=$(lsblk -no FSTYPE "$DEVICE_PATH" | tr -d '[:space:]')
case "$FSTYPE" in
	vfat|exfat|ntfs|msdos)
		MOUNT_OPTS="-o flush,gid=storage,umask=002"
		;;
	ext2|ext3|ext4|xfs|btrfs|f2fs)
		MOUNT_OPTS="-o sync"
		;;
	*)
		MOUNT_OPTS="-o sync"
		;;
esac



mkdir -p "$MOUNT_POINT" || exit 1
mount $MOUNT_OPTS "/dev/$DEVICE" "$MOUNT_POINT" || exit 1
chown :storage "$MOUNT_POINT" 2>/dev/null || true

/usr/local/bin/notify-all-users.sh "Flash disk mounted" "Device $DEVICE successfully mounted to $MOUNT_POINT\nFile system: $FSTYPE"
