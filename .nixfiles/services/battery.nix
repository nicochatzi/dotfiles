{ pkgs, ... }: {
  systemd.user = {
    services.check-battery = {
      enable = true;
      wantedBy = [ "default.target" ];
      path = [ pkgs.dunst ];
      script = ''
        threshold=20
        battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
        is_on_ac=$(cat /sys/class/power_supply/AC/online)

        if [ "$battery_level" -lt $threshold ] && [ "$is_on_ac" -eq 0 ]; then
          ${pkgs.dunst}/bin/dunstify -u critical -h string:x-dunst-stack-tag:battery \
            "Low Battery" "Battery level is low: $battery_level%"
        fi
      '';
    };
    timers.check-battery = {
      enable = true;
      wantedBy = [ "timers.target" ];
      partOf = [ "check-battery.service" ];
      timerConfig = {
        OnBootSec = "10s";
        OnUnitInactiveSec = "30s";
      };
    };
  };
}
