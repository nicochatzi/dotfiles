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

  services.thermald.enable = true;

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "nico" ];
  };
}
