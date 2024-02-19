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
    xkb = {
      layout = "gb";
      variant = "";
      options = "caps:escape";
    };
  };

  console.useXkbConfig = true;

  programs.nix-ld.enable = true;

  programs.zsh = {
    enable = true;
    initExtra = ''
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    '';
  };

  environment.variables = with pkgs; {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "brave";
    OPENSSL_DEV = openssl.dev;
    PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  };

  environment.systemPackages = with pkgs; [
    # tools
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
    llvmPackages_17.libcxx
    lua5_4
    nodejs
    yarn
    protobuf
    rustup
    valgrind
    kcachegrind
    zig

    cargo-generate
  ];
}
