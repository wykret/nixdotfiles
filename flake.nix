{
  description = "Lucas NixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    iloader.url = "github:nab138/iloader";
  };

  outputs = { self, nixpkgs, home-manager, iloader, ... }@inputs:
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

              home.packages = [
                iloader.packages.${system}.default
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

              home.packages = [
                iloader.packages.${system}.default
              ];
            };
          }
        ];
      };

    };
  };
}
