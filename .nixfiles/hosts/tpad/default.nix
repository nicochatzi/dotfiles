{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../system/desktop.nix
    ../../system/firewall.nix
    ../../system/lsp.nix
    # ../../services/rclone.nix
    ../../services/hibernate.nix
    ../../services/bluetooth.nix
    ../../services/battery.nix
    ../../services/feeds.nix
  ];

  networking.hostName = "tpad";

  # keyboard layout toggling
  environment.systemPackages = [ pkgs.xkeyboard_config ];
  services.xserver.xkb = {
    options = "caps:escape,grp:win_space_toggle";
    layout = "us,us(intl)";
  };

  # # encrypt main partition: ./hardware-configuration.nix
  # boot.initrd.luks.devices.cryptroot.device =
  #   "/dev/disk/by-uuid/599c0d05-93c3-4bdd-988e-8640e3a7ff5e";
  #
  # # speed up boot: https://nixos.wiki/wiki/Full_Disk_Encryption#Perf_test
  # boot.initrd.availableKernelModules = [
  #   "aesni"
  #   # crypto coprocessor
  #   "ccp"
  #   "cryptd"
  # ];
  #
  # # allows microcode updates: ./hardware-configuration.nix
  # hardware.enableRedistributableFirmware = true;
  #
  # swapDevices = [{
  #   device = "/swapfile";
  #   size = 10000;
  # }];
}

