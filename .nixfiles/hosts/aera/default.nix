{ ... }: {
  imports = [
    # ./hardware-configuration.nix
    ../../system/desktop.nix
    ../../system/firewall.nix
    ../../services/rclone.nix
    ../../services/hibernate.nix
  ];

  networking.hostName = "aera";
}
