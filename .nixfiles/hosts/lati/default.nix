{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../system/desktop.nix
    ../../system/firewall.nix
    ../../system/lsp.nix
    ../../services/rclone.nix
    ../../services/hibernate.nix
    ../../services/bluetooth.nix
    ../../services/battery.nix
    ../../services/feeds.nix
  ];

  networking.hostName = "lati";
  services.xserver.xkb = {
    layout = "gb";
    options = "caps:escape";
  };

  powerManagement.enable = true;
}
