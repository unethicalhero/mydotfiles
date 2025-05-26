#!/bin/bash

# See README.md for usage instructions
volume_step=5
brightness_step=10  # Set step size for brightness control
max_volume=100
notification_timeout=1000
download_album_art=true
show_album_art=true
show_music_in_volume_indicator=true

# Uses regex to get volume from pactl
function get_volume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

# Uses regex to get mute status from pactl
function get_mute {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}

# Returns a mute icon, a volume-low icon, or a volume-high icon, depending on the volume
function get_volume_icon {
    volume=$(get_volume)
    mute=$(get_mute)
    if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ] ; then
        volume_icon=""
    elif [ "$volume" -lt 50 ]; then
        volume_icon=""
    else
        volume_icon=""
    fi
}

# Always returns the same icon - I couldn't get the brightness-low icon to work with fontawesome
function get_brightness_icon {
    brightness_icon=""
}

# Get current brightness (raw value)
function get_current_brightness {
    brightnessctl g
}

# Get maximum brightness (raw value)
function get_max_brightness {
    brightnessctl m
}

# Calculate brightness percentage
function get_brightness_percentage {
    current_brightness=$(get_current_brightness)
    max_brightness=$(get_max_brightness)
    
    # Calculate the brightness percentage
    brightness_percentage=$(( (current_brightness * 100) / max_brightness ))

    echo $brightness_percentage
}

# Displays a volume notification
function show_volume_notif {
    volume=$(get_mute)
    get_volume_icon

    if [[ $show_music_in_volume_indicator == "true" ]]; then
        current_song=$(playerctl -f "{{title}} - {{artist}}" metadata)

        if [[ $show_album_art == "true" ]]; then
            get_album_art
        fi

        notify-send -t $notification_timeout -h string:x-dunst-stack-tag:volume_notif -h int:value:$volume -i "$album_art" "$volume_icon $volume%" "$current_song"
    else
        notify-send -t $notification_timeout -h string:x-dunst-stack-tag:volume_notif -h int:value:$volume "$volume_icon $volume%"
    fi
}

# Displays a brightness notification using dunstify
function show_brightness_notif {
    brightness_percentage=$(get_brightness_percentage)
    get_brightness_icon
    notify-send -t $notification_timeout -h string:x-dunst-stack-tag:brightness_notif -h int:value:$brightness_percentage "$brightness_icon $brightness_percentage%"
}

# Main function - Takes user input, "volume_up", "volume_down", "brightness_up", or "brightness_down"
case $1 in
    volume_up)
    pactl set-sink-mute @DEFAULT_SINK@ 0
    volume=$(get_volume)
    if [ $(( "$volume" + "$volume_step" )) -gt $max_volume ]; then
        pactl set-sink-volume @DEFAULT_SINK@ $max_volume%
    else
        pactl set-sink-volume @DEFAULT_SINK@ +$volume_step%
    fi
    show_volume_notif
    ;;

    volume_down)
    pactl set-sink-volume @DEFAULT_SINK@ -$volume_step%
    show_volume_notif
    ;;

    volume_mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    show_volume_notif
    ;;

    brightness_up)
    brightnessctl set ${brightness_step}%+
    show_brightness_notif
    ;;

    brightness_down)
    brightnessctl set ${brightness_step}%- 
    show_brightness_notif
    ;;

    next_track)
    playerctl next
    sleep 0.5 && show_music_notif
    ;;

    prev_track)
    playerctl previous
    sleep 0.5 && show_music_notif
    ;;

    play_pause)
    playerctl play-pause
    show_music_notif
    ;;
esac

