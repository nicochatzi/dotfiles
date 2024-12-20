{ pkgs, ... }: {
  systemd.user = {
    services.check-feeds = {
      enable = true;
      wantedBy = [ "default.target" ];
      path = [ pkgs.nix pkgs.bash ];
      serviceConfig = {
        ExecStart = "${pkgs.just}/bin/just -f ~/.scripts/xctl feeds-check";
        WorkingDirectory = "/home/nico/.scripts/";
      };
      environment = {
        User = "nico";
        Display = ":0";
        DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/%U/bus";
        XAUTHORITY = "/home/nico/.Xauthority";
      };
    };
    timers.check-feeds = {
      enable = true;
      wantedBy = [ "timers.target" ];
      partOf = [ "check-feeds.service" ];
      timerConfig = {
        OnBootSec = "30s";
        OnUnitInactiveSec = "60s";
      };
    };
  };
}
