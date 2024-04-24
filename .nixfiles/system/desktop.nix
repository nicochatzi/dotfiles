{ lib, pkgs, ... }: {
  imports = [ ./common.nix ];

  hardware = {
    ledger.enable = true;
    pulseaudio.enable = true;
  };

  sound = { enable = true; };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = false;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        disableWhileTyping = true;
        tapping = false;
        tappingDragLock = false;
      };
    };
    windowManager = { i3.enable = true; };
    displayManager = {
      lightdm = {
        enable = true;
        greeter.enable = true;
        greeters.slick = {
          enable = true;
          draw-user-backgrounds = true;
          font.name = "JetBrains Mono";
        };
      };
      autoLogin = {
        enable = false;
        user = "nico";
      };
    };
    autoRepeatDelay = 250;
    autoRepeatInterval = 25;
    xkb = {
      layout = "gb";
      variant = "";
      options = "caps:escape";
    };
  };

  console.useXkbConfig = true;

  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
    lidSwitch = "suspend";
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
    extraGroups = [ "wheel" "docker" ];
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

      # basic apps
      neovim
      neovim-remote
      tmux
      zsh
      alacritty
      firefox

      # wrapped commands
      (pkgs.writeScriptBin "delta" ''
        command ${pkgs.delta}/bin/delta --$(xctl theme) "$@"
      '')
      (pkgs.writeScriptBin "bat" ''
        command ${pkgs.bat}/bin/bat --theme=gruvbox-$(xctl theme) "$@"
      '')
      (pkgs.writeScriptBin "btm" ''
        color="gruvbox"
        if [[ $(xctl theme) == "light" ]]; then color="gruvbox-light"; fi
        command ${pkgs.bottom}/bin/btm --color $color "$@"
      '')
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "1password-gui" "1password" ];
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "nico" ];
  };

  environment.variables = with pkgs; {
    EDITOR = "nvim";
    BROWSER = "firefox";
    OPENSSL_DEV = openssl.dev;
    PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  };
}
