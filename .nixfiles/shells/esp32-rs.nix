let
  ldproxy-overlay = import ../overlays/ldproxy.nix;
  pkgs = import <nixpkgs> {overlays = [ldproxy-overlay];};
in
  pkgs.mkShell {
    name = "esp32-rs";
    buildInputs = with pkgs; [
      # for std-based development
      # from: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/linux-macos-setup.html#for-linux-users
      git
      wget
      flex
      bison
      gperf
      (python311.withPackages (ps:
        with ps; [
          pip
          venvShellHook
        ]))
      ninja
      cmake
      ccache
      libffi
      openssl
      dfu-util
      libusb1
      # cargo tools
      ldproxy
      espup
      cargo-espflash
      cargo-espmonitor
    ];
  }
