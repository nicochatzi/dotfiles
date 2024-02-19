{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/desktop.nix
    ../../system/firewall.nix
    ../../services/rclone.nix
    ../../services/hibernate.nix
    ../../services/bluetooth.nix
  ];

  networking.hostName = "lati";

  powerManagement.enable = true;
}
