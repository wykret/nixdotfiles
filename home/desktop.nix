{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
  ];
  home.file.".config/scripts" = {
    source = ../config/scriptsdesktop;
  };

}
