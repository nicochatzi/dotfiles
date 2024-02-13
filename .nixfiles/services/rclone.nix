{ pkgs, ... }:

let
  mountdir = "/home/nico/cloud/gdrive";
in
{
  environment.systemPackages = [ pkgs.rclone ];

  networking.networkmanager.enable = true;

  environment.etc."fuse.conf".text = ''
    user_allow_other
  '';

  systemd.user.services.rclone-mount = {
    description = "Mount Google Drive using rclone";
    after = [ "network-online.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${mountdir}";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount gdrive: ${mountdir} \
          --log-level NOTICE \
          --vfs-cache-mode full \
          --vfs-cache-max-size 500G \
          --vfs-cache-max-age 336h \
          --bwlimit-file 16M
      '';
      # ExecStop = "/run/wrappers/bin/fusermount -u ${mountdir}";
      Restart = "always";
      RestartSec = "10s";
      Environment = [ "PATH=${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
    };
  };
}

