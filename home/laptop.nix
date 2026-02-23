{ config, pkgs, ... }:

{
    services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 49.0;
    longitude = 8.4;
  };

  home.packages = with pkgs; [
    blueman
    swaybg
    swaynotificationcenter
    networkmanagerapplet
    powertop
    brightnessctl
  ];
  home.file.".config/sway" = {
    source = ../config/sway;
  };
  home.file.".config/scripts" = {
    source = ../config/scriptslaptop;
  };
  home.file.".config/libinput-gestures.conf" = {
    source = ../config/libinput-gestures.conf;
  };
}
