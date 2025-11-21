{ config, pkgs, inputs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		inputs.noctalia.packages.${config.nixpkgs.system}.default
	];
}
