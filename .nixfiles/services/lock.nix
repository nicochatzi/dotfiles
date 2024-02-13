{ ... }:

{
  systemd.services.lock-before-suspend = {
    description = "Lock screen before suspend";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/dm-tool switch-to-greeter";
      Environment = [
        "XAUTHORITY=/home/nico/.Xauthority"
        "DISPLAY=:0"
        "XDG_SEAT_PATH=/org/freedesktop/DisplayManager/Seat0"
      ];
    };
  };
}
