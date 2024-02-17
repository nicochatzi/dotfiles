{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  users.users.nico = {
    isNormalUser = true;
    description = "nico";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      zsh
      vim
    ];
  };

  environment.variables = with pkgs; {
    EDITOR = "vim";
    OPENSSL_DEV = openssl.dev;
    PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  };
}

