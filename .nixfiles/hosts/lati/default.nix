{ inputs, pkgs, config, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "lati";

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "nico" ];
  };
}
