
_write_file() {

	FILE_PATH="$ARTIFACTS_DIR/$1"

	if [[ -f "$FILE_PATH" ]]
	then
		rm -rf "$FILE_PATH"
	fi
	touch "$FILE_PATH"


	if [[ -n "$3" ]]
	then
		echo "writing $FILE_PATH header..."
		echo "$3" >> "$FILE_PATH"
	fi

	if "$2" "$FILE_PATH"
	then
		echo "config file $FILE_PATH written."
		return 0
	else
		echo "error writing $FILE_PATH...."
		return 1
	fi
}


_write_vendor_data() {
	# Does nothing
	return 0
}

_write_meta_data() {
	export FULL_ID="$HOST_ID/$HOST_NAME"
	yq -i '.instance-id = strenv(FULL_ID)' "$1"
	yq eval '.' "$1"
}

_write_user_data() {
	export STANDARD_USER_PASSWORD
	yq -i '.password = strenv(STANDARD_USER_PASSWORD)' "$1"
	yq -i '.chpasswd.expire = False' "$1"
	yq eval '.' "$1"
}


setup_user_data() {
	_write_file "user-data" _write_user_data "#cloud-config"
}

setup_meta_data() {
	_write_file "meta-data" _write_meta_data
}

setup_vendor_data() {
	_write_file "vendor-data" _write_vendor_data
}




