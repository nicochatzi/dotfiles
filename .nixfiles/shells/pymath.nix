with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "pymath";
  buildInputs = [
    (python311.withPackages
      (ps: with ps; [ numpy matplotlib scipy pandas ipython ]))
  ];
}
