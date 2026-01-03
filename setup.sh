#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]})")")"

if [[ ! -f env.conf ]];
then
	echo "Creating local env file...."
	cp env.example env.conf
	echo "Local 'env.conf' created."
	echo "Please, fill 'env.conf' with the provisioning configurations."
	exit 1
fi


. "$SCRIPT_DIR/env.conf"
. "$SCRIPT_DIR/lib/cloudinit-config.sh"
. "$SCRIPT_DIR/lib/image-config.sh"

ARTIFACTS_DIR="$SCRIPT_DIR/artifacts"

if [[ ! -d "$ARTIFACTS_DIR" ]]
then
	echo "creating artifacts folder"
	mkdir -p "$ARTIFACTS"
fi


if [[ ! -n "$STANDARD_USER_PASSWORD" ]]
then
	echo "ERROR! standard user password not defined, aborting..."
	exit 1
fi


setup_user_data

setup_meta_data

setup_vendor_data


if [[ ! -n "$IMAGE_URL" ]]
then
	echo "ERROR! Can't find IMAGE_URL...."
	echo "Please add IMAGE_URL to env.conf with the url to the desired image"
	echo "exiting...."
	exit 1
fi

IMAGE_PATH="$ARTIFACTS_DIR/downloaded_image.img"
OVERLAY_PATH="$ARTIFACTS_DIR/overlay.qcow2"


if [[ -f "$IMAGE_PATH" ]]
then
	echo "WARNING! image file already exists"
	echo "Do you want to download it again? (y/*)"
	read CHOICE
else
	CHOICE="y"

fi

if [[ "$CHOICE" == "y" ]]
then
	rm -f "$IMAGE_PATH"
	wget -O "$IMAGE_PATH" "$IMAGE_URL"
	WGET_PID=$!
	wait $WGET_PID
	echo "Download Completed"
fi

if [[ -f "$OVERLAY_PATH" ]]
then
	echo "WARNING! overlay file already exists"
	echo "Do you want to create it again? (y/*)"
	read CHOICE
else
	CHOICE="y"
fi

if [[ "$CHOICE" == "y" ]]
then
	BACKING_FORMAT=$(qemu-img info --output=json "$IMAGE_PATH" | jq -r '.format')
	rm -f "$OVERLAY_PATH"
	qemu-img create -f qcow2 -b "$IMAGE_PATH" -F "$BACKING_FORMAT" "$OVERLAY_PATH"
fi

echo ""
echo ""
echo ""
echo "Setup finished"
