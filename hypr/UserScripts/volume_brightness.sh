notification_timeout=1000

function get_volume {
	wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f", $2 * 100}'
}

function get_mute {
	if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '\[MUTED\]'; then
		echo "yes"
	else
		echo "no"
	fi
}

function get_brightness {
	brightnessctl | grep -Po '[0-9]+(?=%)'
}

function get_volume_icon {
	volume=$(get_volume)
	mute=$(get_mute)
	if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ]; then
		volume_icon=""
	elif [ "$volume" -lt 50 ]; then
		volume_icon=""
	else
		volume_icon=""
	fi
}

function get_mic_icon {
	if wpctl get-volume 57 | grep -q '\[MUTED\]'; then
		mic_icon=""
	else
		mic_icon=""
	fi
}

function get_brightness_icon {
	brightness_icon=""
}

function show_volume_notif {
	volume=$(get_mute)
	get_volume_icon
	dunstify -t $notification_timeout -h string:x-dunst-stack-tag:volmicbri -h int:value:$volume "$volume_icon   $volume%"
}

function show_mic_notif {
	get_mic_icon
	dunstify -t $notification_timeout -h string:x-dunst-stack-tag:volmicbri "$mic_icon"
}

function show_brightness_notif {
	brightness=$(get_brightness)
	echo $brightness
	get_brightness_icon
	dunstify -t $notification_timeout -h string:x-dunst-stack-tag:volmicbri -h int:value:$brightness "$brightness_icon $brightness%"
}

case $1 in
volume_up)
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
	wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
	volume=$(get_volume)
	show_volume_notif
	;;
volume_down)
	# Raises volume and displays the notification
	wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-
	show_volume_notif
	;;
volume_mute)
	# Toggles mute and displays the notification
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
	show_volume_notif
	;;
mic_mute)
	wpctl set-mute 57 toggle
	show_mic_notif
	;;
brightness_up)
	brightnessctl s 5%+
	show_brightness_notif
	;;
brightness_down)
	brightnessctl s 5%-
	show_brightness_notif
	;;

esac
