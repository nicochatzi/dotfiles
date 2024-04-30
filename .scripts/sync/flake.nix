{
  description = "rust dev env";

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

      in {
        devShell = pkgs.stdenv.mkDerivation {
          name = "rust-cmake-env";
          buildInputs = [
            (pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml-pinned)
            pkgs.cargo-watch
            pkgs.cargo-limit
            pkgs.git
            pkgs.gh
            pkgs.jq
            pkgs.just
          ];
        };
      });
}
