while true; do
    battery_level=$(cat /sys/class/power_supply/BAT0/capacity)

    if [ "$battery_level" -lt 20 ]; then
        dunstify -u critical -h string:x-dunst-stack-tag:battery "Low Battery" "Battery level is low: ${battery_level}%"
    fi

    sleep 10
done

