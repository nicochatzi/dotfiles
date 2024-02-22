with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "cargo";
  buildInputs = [
    cargo-nextest
    cargo-watch
    cargo-limit
    cargo-bloat
    cargo-deny
    cargo-show-asm
    cargo-binutils
    cargo-lambda
  ];
}
