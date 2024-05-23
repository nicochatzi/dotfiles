{
  description = "A Rust and CMake development environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays.default = [ rust-overlay.overlay ];
        };

        rust-pinned = if builtins.pathExists ./rust-toolchain.toml then
          pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml
        else
          pkgs.rust-bin.stable.latest.default;

      in {
        devShell = pkgs.stdenv.mkDerivation rec {
          name = "rust-cmake-env";
          buildInputs = [
            rust-pinned
            pkgs.cmake
            pkgs.pkg-config
            pkgs.alsa-lib
            pkgs.llvmPackages.clang
            pkgs.llvmPackages.libclang
            pkgs.llvmPackages.bintools
          ];

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ buildInputs ];
          LIBCLANG_PATH =
            pkgs.lib.makeLibraryPath [ pkgs.llvmPackages.libclang.lib ];
          CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG = "true";
        };
      });
}
