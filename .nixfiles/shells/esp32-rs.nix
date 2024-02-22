with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "esp32-rs";
  buildInputs = [ cargo-espflash cargo-espmonitor ];
}
