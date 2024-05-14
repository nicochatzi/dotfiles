{ lib, pkgs, ... }: {
  imports = [ ./common.nix ];

  hardware = {
    ledger.enable = true;
  };

  security.rtkit.enable = true;

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
        enable = true;
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

  users.users.nico = {
    isNormalUser = true;
    initialHashedPassword = "$6$BnzWijwCFBvZb8Gu$p54z1dS.sXG2mZ1w10TgPjap5pa/gJpvtFIWaOCDZyWtYFKJSf8WNZ0P3ltJmD10CtNyD45Cq0h45.RyA0A0w0";
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

      # term
      neovim
      neovim-remote
      tmux
      zsh

      # apps
      alacritty
      firefox
      gimp
      obs-studio
      reaper
      # bitwig-studio
      # ledger-live-desktop
      gpick

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
    vscode-langservers-extracted # provides html, css, json, eslint
    yaml-language-server
    zls
  ];

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
    BROWSER = "brave";
    OPENSSL_DEV = openssl.dev;
    PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  };
}
