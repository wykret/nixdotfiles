{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
  ];
  hardware.bluetooth.enable = true;
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sdb"; # ajuste se for nvme
      useOSProber = true;
    };
  };

  networking.hostName = "lucas-laptop";
  users.users.lucas.extraGroups = [ "input" ];
  environment.systemPackages = with pkgs; [
  libinput-gestures
];

}

