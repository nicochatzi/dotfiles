with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "default-py-pkgs";
  buildInputs = [
    (python312.withPackages (ps:
      with ps; [
        numpy
        matplotlib
        scipy
        pandas
        librosa
        pyaudio
        python-rtmidi
        ipython
      ]))
  ];
}
