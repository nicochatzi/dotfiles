{ lib, pkgs, ... }: {
  imports = [ ./common.nix ];

  hardware = {
    ledger.enable = true;
    pulseaudio.enable = true;
  };

  # sound = { enable = true; };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = false;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      disableWhileTyping = true;
      tapping = false;
      tappingDragLock = false;
    };
  };

  services.displayManager = {
    autoLogin = {
      enable = false;
      user = "nico";
    };
  };

  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
    lidSwitch = "suspend";
  };

  console.useXkbConfig = true;
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    windowManager = { i3.enable = true; };
    autoRepeatDelay = 250;
    autoRepeatInterval = 25;
    displayManager = {
      lightdm = {
        enable = true;
        greeters.slick = {
          enable = true;
          font.name = "JetBrains Mono";
        };
      };
    };
  };

  location.provider = "geoclue2";
  services.redshift = {
    enable = true;
    brightness = {
      day = "0";
      night = "1";
    };
    temperature = {
      day = 25000;
      night = 4000;
    };
  };

  services.thermald = { enable = true; };

  users.users.nico = {
    isNormalUser = true;
    description = "nico";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "video" "lightdm" ];
    packages = with pkgs; [
      # system
      i3
      i3status
      picom # compositor
      nitrogen # wallpaper
      xdg-utils
      xclip # clipboard
      maim # screenshots
      rofi # dmenu
      dunst # notifications
      pulseaudio
      alsa-lib
      brightnessctl

      # basics
      neovim
      neovim-remote
      tmux
      zsh
      fzf
      alacritty
      kitty
      firefox
      # privacy
      ledger-live-desktop
      # audio
      reaper
      audacity
      bitwig-studio
      # image
      gimp
      gpick
      # work
      slack
      zoom-us
      obs-studio
      obsidian
      pre-commit
      kicad
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "zoom-us" "obsidian" ];
  };

  environment.systemPackages = with pkgs; [
    xorg.xorgserver
    xorg.xinit
    xorg.xauth
  ];

  environment.variables = with pkgs; {
    EDITOR = "nvim";
    BROWSER = "firefox";
    OPENSSL_DEV = openssl.dev;
    PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  };
}
