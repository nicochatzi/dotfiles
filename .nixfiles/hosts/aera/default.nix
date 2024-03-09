{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./apple-silicon-support
    ../../system/desktop.nix
    ../../system/firewall.nix
    ../../services/rclone.nix
    ../../services/hibernate.nix
  ];

  hardware.asahi.peripheralFirmwareDirectory = /boot/asahi;
  # hardware.pulseaudio.enable = true;
  # sound.enable = true;

  services.xserver.dpi = 144;

  networking.hostName = "aera";
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
}
