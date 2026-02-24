{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
  ];
  hardware.bluetooth.enable = true;
  xdg.portal = {
  enable = true;
  wlr.enable = true;
  xdgOpenUsePortal = true;
};
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sdb"; # ajuste se for nvme
      useOSProber = true;
    };
  };
  # Enable Sway.
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  networking.hostName = "lucas-laptop";
  users.users.lucas.extraGroups = [ "input" ];
  environment.systemPackages = with pkgs; [
  libinput-gestures
];

}

