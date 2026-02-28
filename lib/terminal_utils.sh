open_in_new_terminal() {
	local CMD=("$@")

	if [[ -n "$TERMINAL" ]]
	then

		case "$TERMINAL" in

			"kitty")
				if command -v kitty &> /dev/null
				then
					echo "using kitty"
					kitty @ launch --type=window  --cwd=current -- "${CMD[@]}" &
					return 0
				else
					echo "kitty is not available"
					echo "defaulting to xterm"
				fi
				;;

			"alacritty")
				if command -v alacritty &> /dev/null
				then
					echo "using alacritty"
					alacritty -e "${CMD[@]}" &
					echo $!
				else
					echo "alacritty is not available"
					echo "defaulting to xterm"
				fi
				;;

			"konsole")
				if command -v konsole &> /dev/null
				then
					echo "using konsole"
					konsole -e "${CMD[@]}" &
					echo $!
				else
					echo "konsole is not available"
					echo "defaulting to xterm"
				fi
				;;

			"gnome-terminal")
				if command -v gnome-terminal &> /dev/null
				then
					echo "using gnome-terminal"
					gnome-terminal -- "${CMD[@]}" &
					echo $!
				else
					echo "gnome-terminal is not available"
					echo "defaulting to xterm"
				fi
				;;

			"xfce4-terminal")
				if command -v xfce4-terminal &> /dev/null
				then
					echo "using xfce4-terminal"
					xfce4-terminal --window -e "${CMD[@]}" &
					echo $!
				else
					echo "xfce4-terminal is not available"
					echo "defaulting to xterm"
				fi
				;;

			"xterm")
				echo "xterm"
				;;

			*)
				echo "Unknown terminal"
				echo "defaulting to xterm"
				;;

		esac

		if command -v xterm &> /dev/null
		then
			xterm -e "${CMD[@]}" &
			echo $!
		else
			echo "ERROR!!! xterm not found"
			echo "aborting...."
			exit 1
		fi


	fi
}


if [[ -f "$1" ]]
then
	echo "WARNING! image file already exists"
	echo "Do you want to download it again? (y/*)"
	read CHOICE

	if [[ "$CHOICE" == "y" ]]
	then
		rm -f "$IMAGE_PATH"
		wget -O "$IMAGE_PATH" "$IMAGE_URL"
		WGET_PID=$!
		wait $WGET_PID
		echo "Download Completed"
	fi
fi

check_ask_and_wait() {
	local CHOICE
	local FOUND=$(test -e "$1")

	if "$FOUND"
	then
		echo "WARNING! $2 already exists"
		echo "Do you want to overwrite it? (y/*)"
		read CHOICE
	else
		CHOICE="y"
	fi

	if [[ "$CHOICE" == "y" ]]
	then
		"$3"
		PID=$!
		wait PID
	fi




}
