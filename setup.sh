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


if [[ -n "$IMAGE_NAME" ]]
then
	download_image "$IMAGE_URL" "$ARTIFACTS_DIR" "$IMAGE_NAME"
else
	download_image "$IMAGE_URL" "$ARTIFACTS_DIR"
fi




