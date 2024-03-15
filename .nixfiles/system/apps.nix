{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gimp
    obs-studio
    reaper
    bitwig-studio
    ledger-live-desktop
    gpick
  ];
}

