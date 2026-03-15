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
    waybar
    swaybg
    swaylock
    swaynotificationcenter
    networkmanagerapplet
    powertop
    brightnessctl
  ];
  wayland.windowManager.sway = {
  enable = true;
  package = pkgs.swayfx;
  
  # Needed to build without errors.
  checkConfig = false;
    
  # SwayFX options must be configured through extraConfig.
  extraConfig = ''
    shadows enable
    corner_radius 11
    blur_radius 7
    blur_passes 2
  '';

};

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
