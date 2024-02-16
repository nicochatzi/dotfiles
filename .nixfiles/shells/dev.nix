with import <nixpkgs> {};
stdenv.mkDerivation {
  LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";
  name = "dev-environment";
  buildInputs = [
    pkg-config
    zlib
    alsa-lib
    lua
    lua5_4_compat
    clang
    llvmPackages.libclang
    lldb_17
    glibc
    glibc.static
    gcc
  ];
}
