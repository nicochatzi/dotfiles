# bootstrapping dev shell
with import <nixpkgs> {};
  pkgs.mkShell {
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [nix git];
  }
