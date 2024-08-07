{
  description = "nixOS config";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };

  outputs = { nixpkgs, ... }: {
    nixosConfigurations = {
      tpad = nixpkgs.lib.nixosSystem {
        system = "x86-64-linux";
        modules = [ ./hosts/tpad ];
      };
      lati = nixpkgs.lib.nixosSystem {
        system = "x86-64-linux";
        modules = [ ./hosts/lati ];
      };
      aera = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/aera ];
      };
    };
  };
}
