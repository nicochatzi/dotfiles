with import <nixpkgs> { };

stdenv.mkDerivation {
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
  ];

  LIBCLANG_PATH = lib.makeLibraryPath [ llvmPackages.libclang.lib ];
  LLDB_PATH = "${lldb_17}/bin/lldb";
  LLDB_SERVER_PATH = "${lldb_17}/bin/lldb-server";
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
}
