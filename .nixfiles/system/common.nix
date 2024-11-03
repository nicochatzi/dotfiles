{ pkgs, ... }: {
  # https://github.com/NixOS/nixpkgs/pull/50112
  system.stateVersion = "24.04";

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
    '';
  };

  boot = {
    # kernelPackages = pkgs.linuxPackages_rt_6_1;
    tmp.cleanOnBoot = true;
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    # https://nixos.wiki/wiki/Docker
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    # https://nixos.wiki/wiki/Podman
    podman = {
      enable = false;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
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
    wireless.iwd = {
      enable = false;
      settings = {
        Settings = { AutoConnect = true; };
        General.EnableNetworkConfiguration = true;
      };
    };
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
    zsh
    pkg-config
    openssl
    vim
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
    parallel
    jq
    bat
    bottom
    delta
    du-dust
    eza
    fd
    hyperfine
    ripgrep
    watchexec
    awscli2
    tokei
    just
    dive
    docker-compose

    # (pkgs.writeScriptBin "docker" ''
    #   command ${pkgs.podman}/bin/podman "$@"
    # '')
    # (pkgs.writeScriptBin "docker-compose" ''
    #   command ${pkgs.podman-compose}/bin/podman-compose "$@"
    # '')

    # languages
    (python312.withPackages (py: [ py.requests ]))
    cmake
    ninja
    gnumake
    gcc
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
    bacon
    espup
    valgrind
    kcachegrind
    zig
    cargo-generate
  ];
}
