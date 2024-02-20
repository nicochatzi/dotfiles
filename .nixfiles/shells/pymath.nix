with import <nixpkgs> { };
let
  pyPacked = python311.withPackages
    (ps: with ps; [ numpy matplotlib scipy pandas ipython ]);
in stdenv.mkDerivation {
  name = "pymath";
  buildInputs = [ pyPacked ];
}
