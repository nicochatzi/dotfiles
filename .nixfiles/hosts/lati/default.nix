{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../system/desktop.nix
    ../../system/firewall.nix
    ../../services/rclone.nix
    ../../services/hibernate.nix
    ../../services/bluetooth.nix
    ../../services/battery.nix
    ../../services/feeds.nix
  ];

  networking.hostName = "lati";

  services.thermald = { enable = true; };

  powerManagement.enable = true;

  hardware = {
    pulseaudio.enable = true;
  };

  sound = { enable = true; };
  services.pipewire = {
    enable = false;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
