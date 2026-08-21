#!/usr/bin/env bash
DEVICE="$1"
MOUNT_POINT="/mnt/usb/$DEVICE"

# Find mount point
if mountpoint -q "$MOUNT_POINT"; then
	if [[ ! -b "/dev/$DEVICE" ]]; then
		# Removing without umounting
		/usr/bin/umount -l "$MOUNT_POINT" 2>/dev/null || true
		rmdir "$MOUNT_POINT" 2>/dev/null || true
		/usr/local/bin/notify-all-users.sh "⚠️ USB removed" "Device $DEVICE removed without umounting! Data may be corrupted. $(cat /proc/mounts | grep usb)"
		exit 0
	fi
else
	# Point not mounted yet
	if [ ! -b "/dev/$DEVICE" ]; then
		# Handle umount
		/usr/local/bin/notify-all-users.sh "USB removed" "Device $DEVICE removed. $(cat /proc/mounts | grep usb)"
	fi
	exit 0
fi
