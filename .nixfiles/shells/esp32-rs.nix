with import <nixpkgs> { overlays = [ (import ../overlays/ldproxy.nix) ]; };

stdenv.mkDerivation {
  name = "esp32-dev";
  buildInputs = [ ldproxy cargo-espflash cargo-espmonitor ];
}

