with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "dev-environment";
  buildInputs = [
    cmake
    libasound2-dev
    libjack-jackd2-dev
    ladspa-sdk
    libcurl4-openssl-dev
    libfreetype6-dev
    libx11-devlibxcomposite-dev
    libxcursor-dev
    libxcursor-dev
    libxext-dev
    libxinerama-dev
    libxrandr-dev
    libxrender-dev
    (libwebkit2gtk-4 0.0 - dev)
    libglu1-mesa-dev
    mesa-common-dev
  ];
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
}
