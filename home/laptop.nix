{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    powertop
    brightnessctl
  ];
  home.file.".config/scripts" = {
    source = ../config/scriptslaptop;
  };

}
