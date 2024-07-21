{ pkgs, ... }:

let
  jetbrains = pkgs.fetchzip {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip";
    sha256 = "1kc8fyk1aczxkmn8dzv1gy6xfi2jywgahd8np576v2dn8kx16844";
  };

  dejavu = pkgs.fetchzip {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DejaVuSansMono.zip";
    sha256 = "03qfrkzmhnn8dwgx4qhiigbz4dxs3957hydlr0j8vxl89j8c9g1z";
  };

in
  pkgs.stdenv.mkDerivation {
    name = "custom-fonts";
    buildInputs = [ pkgs.fontconfig ];
    installPhase = ''
      mkdir -p  $out/share/fonts
      cp -r ${jetbrains}/* $out/share/fonts/
      cp -r ${dejavu}/* $out/share/fonts
      fc-cache -fv $out/share/fonts
    '';
  }
