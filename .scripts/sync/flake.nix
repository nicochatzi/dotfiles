{
  description = "rust-pinned dev env";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };

      in {
        devShell = pkgs.stdenv.mkDerivation {
          name = "rust-pinned";
          buildInputs = [
            (pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml)
            pkgs.git
            pkgs.rclone
            pkgs.gh
            pkgs.jq
            pkgs.just
            # dev
            pkgs.cargo-watch
            pkgs.cargo-limit
          ];
        };
      });
}
