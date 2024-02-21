{ lib, pkgs, ... }:

let
  vimPacked = import ../modules/vim.nix {
    inherit pkgs;
    full = true;
  };
in {
  imports = [ ./common.nix ];

  hardware = {
    ledger.enable = true;
    pulseaudio.enable = true;
  };

  sound = { enable = true; };

  services.pipewire = {
    enable = false;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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
    extraGroups = [ "networkmanager" "wheel" "docker" ];
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
      openssl
      pkg-config

      # term
      neovim
      neovim-remote
      vimPacked
      tmux
      zsh

      # apps
      alacritty
      brave
      gimp
      obs-studio
      reaper
      bitwig-studio
      ledger-live-desktop
      gpick
    ];
  };

  environment.systemPackages = with pkgs; [
    # language servers / tools
    asm-lsp
    cmake-language-server
    dockerfile-language-server-nodejs
    gopls
    ltex-ls
    lua-language-server
    nil
    nixfmt
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    python311Packages.pylint
    python311Packages.pynvim
    python311Packages.black
    python311Packages.python-lsp-server
    rust-analyzer
    sqls
    taplo
    tflint
    vscode-extensions.vadimcn.vscode-lldb # provides code-lldb for DAP support
    yaml-language-server
    zls
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "1password-gui"
        "1password"
        "obsidian"
      ];
    packageOverrides = pkgs: { inherit vimPacked; };
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "nico" ];
  };

  environment.variables = with pkgs; {
    EDITOR = "nvim";
    BROWSER = "brave";
    OPENSSL_DEV = openssl.dev;
    PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  };
}
