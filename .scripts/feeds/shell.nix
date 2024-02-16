with import <nixpkgs> {}; mkShell {
  buildInputs = [
    python3
    python3Packages.requests
    python3Packages.feedparser
    python3Packages.plyer
    python3Packages.dbus-python
  ];
}

