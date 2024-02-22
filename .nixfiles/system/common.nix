{ pkgs, ... }: {
  system.stateVersion = "23.11";

  nix = {
    # https://nixos.org/manual/nix/stable/command-ref/conf-file
    settings = {
      allowed-users = [ "nico" ];
      auto-optimise-store = true;
      warn-dirty = true;
      show-trace = false;
    };
    # https://nixos.wiki/wiki/Storage_optimization
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
      timeout = 3;
    };
  };

  hardware = {
    ledger.enable = true;
    pulseaudio.enable = true;
  };
  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      openmoji-color
      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        serif = [ "DejaVu" ];
        sansSerif = [ "DejaVu" ];
        monospace = [ "JetBrainsMono" ];
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

  programs = {
    nix-ld.enable = true;
    zsh.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      loadInNixShell = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # tools
    curl
    git
    nix-ld
    patchelf
    binutils
    libiconv
    zlib
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

    # languages
    (python3.withPackages (py: [ py.requests ]))
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
