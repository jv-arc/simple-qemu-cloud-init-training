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

