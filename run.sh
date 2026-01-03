#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]})")")"

#======= Checking ===========

ARTIFACTS_DIR="$SCRIPT_DIR/artifacts"

if [[ ! -d "$ARTIFACTS_DIR" ]]
then
	echo "ERROR! Can't find artifacts directory...."
	echo "Please, make sure to run the setup script and write that the artifacts directory was created correctly before running this again."
	echo "exiting...."
	exit 1
fi

if [[ ! -f "$SCRIPT_DIR/env.conf" ]]
then
	echo "ERROR! Can't find configuration variables...."
	echo "Please, make sure to run the setup script and write the config values before running this again."
	echo "exiting...."
	exit 1
fi

. "$SCRIPT_DIR/env.conf"


IMAGE_NAME="downloaded_image.img"
if [[ ! -n "$IMAGE_NAME" ]]
then
	IMAGE_NAME="${IMAGE_URL##*/}"
fi
	IMG_PATH="$ARTIFACTS_DIR/$IMAGE_NAME"


if [[ ! -f "$IMG_PATH" ]]
then
	echo "ERROR! Image could not be found"
	exit 1
fi


IMDS_ADDR="s=http://$QEMU_GATEWAY:$IMDS_PORT/"
SMBIOS_PARAM="type=1,serial=ds="
SMBIOS_PARAM+="nocloud;"
SMBIOS_PARAM+="$IMDS_ADDR"



#======= RUNNING ===========
. "$SCRIPT_DIR/lib/terminal_utils.sh"


# IMDS Server

echo "Using IMDS at: $IMDS_ADDR"

IMDS_COMMAND=(
	python3
	-m http.server "$IMDS_PORT"
	--directory "$ARTIFACTS_DIR"
)

echo "Starting IMDS server"
open_in_new_terminal "${IMDS_COMMAND[@]}"



# QEMU

IMG_PATH="$ARTIFACTS_DIR/overlay.qcow2"
echo "Using image path: $IMG_PATH"

QEMU_COMMAND=(
    qemu-system-x86_64
    -net nic
    -net user
    -machine accel=kvm:tcg
    -m "$MEM_SIZE"
    -nographic
    -hda "$IMG_PATH"
    -smbios "$SMBIOS_PARAM"
)

echo "${QEMU_COMMAND[@]}"
echo "Starting QEMU VM"
open_in_new_terminal "${QEMU_COMMAND[@]}"

echo "Type anything to exit"
read end

trap "pkil -P $$" EXIT

