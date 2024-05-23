{ pkgs, ... }:
let
  createMountService = name: {
    description = "Mount ${name} using rclone";
    after = [ "network-online.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      Environment = [ "PATH=${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
      ExecStartPre = ''
        ${pkgs.coreutils}/bin/mkdir -p /home/nico/cloud/${name}
      '';
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount ${name}: /home/nico/cloud/${name} \
          --log-level NOTICE \
          --vfs-cache-mode full \
          --vfs-cache-max-size 500G \
          --vfs-cache-max-age 336h \
          --bwlimit-file 16M
      '';
    };
    unitConfig.OnFailure = "rclone-notify-failure@%n.service";
  };

in {
  environment = {
    systemPackages = [ pkgs.rclone pkgs.dunst ];
    etc."fuse.conf".text = ''
      user_allow_other
    '';
  };

  systemd.user.services = {
    rclone-mount-proton = createMountService "proton";
    rclone-mount-gdrive = createMountService "gdrive";
    "rclone-notify-failure@" = {
      description = "Notify rclone failure";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.dunst}/bin/dunstify -u critical '%i failed'
        '';
      };
    };
  };

}

