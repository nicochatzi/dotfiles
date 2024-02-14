{ pkgs, ... }:

{
  system.stateVersion = "23.11";

  nix = {
    settings.auto-optimise-store = true;
    settings.allowed-users = [ "nico" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_rt_6_1;
    tmp.cleanOnBoot = true;
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };

  hardware = {
    ledger.enable = true;
    pulseaudio.enable = true;
  };

  virtualisation = {
    docker.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      ubuntu_font_family
      openmoji-color
      jetbrains-mono
      (nerdfonts.override { fonts = [
        "JetBrainsMono"
      ]; })
    ];

    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        emoji = [ "OpenMoji Color" ];
      };
    };
  };

  networking = {
    networkmanager.enable = true;
    # wireless.enable = true;
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  time.timeZone = "Europe/Paris";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services.cron.enable = true;

  services.xserver = {
    enable = true;
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        disableWhileTyping = true;
        tapping = true;
      };
    };
    windowManager.i3.enable = true;
    displayManager = {
      lightdm = {
        enable = true;
        greeter.enable = true;
        greeters.slick.enable = true;
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

  environment.variables = with pkgs; {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "brave";
    OPENSSL_DEV = openssl.dev;
    PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  };

  environment.systemPackages = with pkgs; [
    # tools
    vim
    curl
    git
    nix-ld
    patchelf
    binutils
    libiconv
    pkg-config
    zlib
    openssl
    wget
    ffmpeg
    file
    unzip
    cron
    parallel
    awscli2
    asciinema
    delta
    jq
    bat
    du-dust
    eza
    fd
    hyperfine
    ripgrep
    watchexec
    bottom
    tokei
    just
    direnv

    # languages
    (python3.withPackages (py: [
      py.requests
    ]))
    python311Packages.pynvim
    poetry
    docker
    maven
    cmake
    ninja
    gcc
    gdb
    gnumake
    go
    llvmPackages_17.bintools
    llvmPackages_17.clang
    llvmPackages_17.lldb
    llvmPackages_17.llvm
    llvmPackages_17.stdenv
    lua5_4
    nil
    nodejs
    yarn
    protobuf
    rustup
    valgrind
    kcachegrind
    zig
    zls

    # cargo
    cargo-nextest
    cargo-bloat
    cargo-cross
    cargo-show-asm
    cargo-binutils
    cargo-watch
    cargo-limit
    cargo-deny
    cargo-lambda
    cargo-update
  ];
}
