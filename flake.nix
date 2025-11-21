{

	description = "Primeiro flake.";
	inputs = {
	  nixpkgs.url = "nixpkgs/nixos-unstable";
	   home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
         };
      quickshell = {
        url = "github:outfoxxed/quickshell";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      noctalia = {
        url = "github:noctalia-dev/noctalia-shell";
        inputs.nixpkgs.follows = "nixpkgs";
      };
  };
	outputs = inputs@{ self, nixpkgs, home-manager, ... }:
	let
	   lib = nixpkgs.lib;
	   system = "x86_64-linux";
	   pkgs = nixpkgs.legacyPackages.${system};
	   in{
		nixosConfigurations = {
			lucas-nixos = lib.nixosSystem{
				inherit system;
        specialArgs = { inherit inputs; };  # ← Adicione esta linha
				modules = [ ./configuration.nix
                    ./noctalia.nix
				];
			};
		};
		homeConfigurations = {
			lucas = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			modules = [ ./home.nix ];
		};
	};

};

}

