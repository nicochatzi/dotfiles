# https://nixos.wiki/wiki/Bluetooth
{ pkgs, ... }: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
  };
  hardware.pulseaudio.extraConfig =
    "\n    load-module module-switch-on-connect\n  ";

  environment = { systemPackages = [ pkgs.bluez ]; };

  services.blueman.enable = true;

  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };
}
