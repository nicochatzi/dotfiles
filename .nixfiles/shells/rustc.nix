with import <nixpkgs> { };

let
  config = writeText "rust-config" ''
    # Includes one of the default files in src/bootstrap/defaults
    profile = "library"
    change-id = 102579

    [llvm]
    # optimize = false
    ccache = true
    ninja = true
    enable-warnings = true

    [build]
    check-stage = 0
    doc-stage = 0
    build-stage = 1
    test-stage = 1
    dist-stage = 2
    install-stage = 2
    bench-stage = 2
    gdb = "${pkgs.gdb}/bin/gdb"
    nodejs = "${pkgs.nodejs}/bin/node"
    python = "${pkgs.python3Full}/bin/python"

    [rust]
    optimize = true
    #debug = false
    #rpath = true
    lld = true
    use-lld = false
    backtrace-on-ice = true
    verify-llvm-ir = false

    [target.x86_64-unknown-linux-gnu]
    #cc = "cc" (path)
    #cxx = "c++" (path)
    #ar = "ar" (path)
    #ranlib = "ranlib" (path)
    #linker = "cc" (path)
    #sanitizers = build.sanitizers (bool)
    #profiler = build.profiler (bool)
    #rpath = rust.rpath (bool)
    #musl-root = build.musl-root (path)
    #wasi-root = <none> (path)
    #qemu-rootfs = <none> (path)
    #no-std = <platform-specific> (bool)
  '';

  rgignore = pkgs.writeText "rust-rgignore" ''
    configure
    config.toml.example
    x.py
    LICENSE-MIT
    LICENSE-APACHE
    COPYRIGHT
    **/*.txt
    **/*.toml
    **/*.yml
    **/*.nix
    *.md
    src/bootstrap
    src/ci
    src/doc/
    src/etc/
    src/llvm-emscripten/
    src/llvm-project/
    src/rtstartup/
    src/rustllvm/
    src/stdsimd/
    src/tools/rls/rls-analysis/test_data/
  '';

in pkgs.mkShell {
  name = "rust";
  buildInputs = with pkgs; [
    git
    gnumake
    cmake
    curl
    clang

    libxml2
    ncurses
    swig

    # If `llvm.ninja` is `true` in `config.toml`.
    ninja
    # If `llvm.ccache` is `true` in `config.toml`.
    ccache
    # Used by debuginfo tests.
    gdb
    # Used with emscripten target.
    nodejs
  ];

  RUST_BACKTRACE = 1;
  RUSTC_CONFIG = config;
  RGIGNORE = rgignore;

  shellHook = ''
    ln -sf ${config} ./config.toml
    ln -sf ${rgignore} ./.rgignore
  '';
}
