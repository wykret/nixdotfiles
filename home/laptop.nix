{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    blueman
    networkmanagerapplet
    powertop
    brightnessctl
  ];
  home.file.".config/scripts" = {
    source = ../config/scriptslaptop;
  };
  home.file.".config/libinput-gestures.conf" = {
    source = ../config/libinput-gestures.conf;
  };
}
