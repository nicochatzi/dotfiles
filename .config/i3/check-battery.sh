while true; do
  battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
  is_on_ac=$(cat /sys/class/power_supply/AC/online)

  if [ "$battery_level" -lt 20 ] && [ "$is_on_ac" -eq 0 ]; then
    dunstify -u critical -h string:x-dunst-stack-tag:battery \
      "Low Battery" "Battery level is low: ${battery_level}%"
  fi

  sleep 10
done
