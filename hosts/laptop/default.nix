{ config, pkgs, ... }:

let
  swayConfig = pkgs.writeText "greetd-sway-config" ''
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'
  '';
in
{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
  ];

      services.greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = "${pkgs.swayfx}/bin/sway";
            user = "lucas";
          };
          default_session = initial_session;
        };
      };


  environment.etc."greetd/environments".text = ''
    sway
  '';

  hardware.bluetooth.enable = true;
  security.pam.services.swaylock = {};
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
  };
    boot = {
    initrd =
    {
      systemd.enable = true;
      kernelModules = [ "i915" ];
      };
      loader = {
        grub = {
          enable = true;
          device = "/dev/sdb";
        };
      };

    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "rings" ];
        })
      ];
    };
    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };

  networking.hostName = "lucas-laptop";

  users.users.lucas.extraGroups = [ "input" ];

  environment.systemPackages = with pkgs; [
    libinput-gestures
    swayfx
    waypaper
  ];
}
