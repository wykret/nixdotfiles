{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
  ];
  #################### DISPLAY MANAGER ####################
  services.displayManager.sddm.enable = true;

  boot.loader.systemd-boot.enable = false;
  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };
    grub = {
      enable = true;
      efiInstallAsRemovable = true;
      useOSProber = true;
      efiSupport = true;
      device = "nodev";
    };
  };

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  networking.hostName = "lucas-desktop";
}

