{ inputs, pkgs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/desktop.nix
    ../../services/rclone.nix
    ../../services/lock.nix
  ];

  networking.hostName = "aera";

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "nico" ];
  };
}
