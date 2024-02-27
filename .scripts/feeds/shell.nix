with import <nixpkgs> { };
mkShell {
  buildInputs = [
    (python311.withPackages
      (p: with p; [ feedparser requests plyer dbus-python ]))
  ];
}

