download_image(){
	if [[ ! -n "$1" ]]
	then
		echo "ERROR! image not found!"
		return 1
	fi

	echo "Downloading image...."

	if [[ -n "$3" ]]
	then
		wget -O "$1" "$2/$3"
	else
		wget -P "$2" "$1"
	fi

	echo "image downloaded"

	return 0
}



