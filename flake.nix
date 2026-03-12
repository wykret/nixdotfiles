{
  description = "Lucas NixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {

    nixosConfigurations = {

      desktop = lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/desktop

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.lucas = {
              imports = [
                ./home/common.nix
                ./home/desktop.nix
              ];
            };
          }
        ];
      };

      laptop = lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/laptop

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.lucas = {
              imports = [
                ./home/common.nix
                ./home/laptop.nix
              ];
            };
          }
        ];
      };

    };
  };
}

