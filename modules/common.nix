{ config, pkgs, ... }:

{
  imports = [];

  #################### BOOT ####################

  #################### NETWORK ####################
  networking.networkmanager.enable = true;
  networking.timeServers = [
    "a.st1.ntp.br"
    "b.st1.ntp.br"
    "time.cloudflare.com"
    "time.google.com"
    "pool.ntp.org"
  ];
nixpkgs.config.permittedInsecurePackages = [
  "olm-3.2.16"
];
networking.firewall = {
  enable = true;

  allowedTCPPorts = [ 
    8096
    49553
  ];

  allowedTCPPortRanges = [
    { from = 1714; to = 1764; }
  ];

  allowedUDPPortRanges = [
    { from = 1714; to = 1764; }
  ];
};
  networking.resolvconf.enable = false;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  services.mpd = {
  enable = true;
  user = "lucas";
  musicDirectory = "/home/lucas/Musicas/";
  extraConfig = ''
   audio_output {
    type "pipewire"
    name "My PipeWire Output"
  }
  '';

};
  #################### TIME / LOCALE ####################
  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  #################### ENV ####################
  environment.variables = {
    EDITOR = "nvim";
  };

  #################### X11 ####################

  services.xserver = {
    enable = true;
    xkb.layout = "br";
    xkb.variant = "";

    desktopManager.xterm.enable = false;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3blocks
      ];
    };
  };


  # Wayland (Plasma Wayland) — comentado pois você usa i3/X11
  # services.displayManager.sddm.wayland.enable = true;

  #services.desktopManager.plasma6.enable = true;
  #services.displayManager.defaultSession = "plasmax11";

  # Wayland WM — exclusivo Wayland, desativado
  # programs.hyprland.enable = true;

  #################### INPUT / HARDWARE ####################
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
  hardware.opentabletdriver.enable = true;
  services.ratbagd.enable = true;

  #################### PRINT / SOUND ####################
  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #################### FLATPAK ####################
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  #################### VIRTUALIZATION ####################
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  #################### USERS ####################
  programs.zsh.enable = true;

  users.users.lucas = {
    isNormalUser = true;
    description = "Lucas";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    packages = with pkgs; [
      fzf
    ];
  };

  #################### PROGRAMS ####################
  programs.firefox.enable = true;
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };
  programs.kdeconnect.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  #################### PACKAGES ####################
  environment.systemPackages = with pkgs; [

    ###browsers
    mullvad-browser

    ### 🖥️ system
    lm_sensors
    acpi
    sysstat
    btop
    fastfetch

    ### files/compression
    zathura
    unzip
    persepolis
    unrar
    p7zip
    file
    ntfs3g

    ### dev
    python3
    gcc
    cmake
    git
    gh
    neovim
    emacs
    jq
    vscodium

    # file manager
  kdePackages.dolphin

    ##########################################
    # Qt6 Breeze theme
    ##########################################
    kdePackages.breeze

    ##########################################
    # Kvantum for Qt6
    ##########################################
    kdePackages.qtstyleplugin-kvantum

    ##########################################
    # Kvantum themes
    ##########################################
    nordic
    sweet
    dracula-theme
    catppuccin-kvantum
    # GVFS + Android MTP support
    gvfs

    # iPhone AFC support
    libimobiledevice
    ifuse

    # Automount daemon for Wayland
    udiskie

    ### 🖱️ X11 / Desktop / WM Utils
    wl-clipboard
    wdisplays
    mako
    lxappearance
    lxrandr
    picom
    maim
    slop
    scrot
    grim
    slurp
    xkill
    dunst
    libnotify
    feh
    arandr
    flameshot
    xclip
    xsel
    kitty
    nwg-look
    qt6Packages.qt6ct
    pavucontrol

    ### audio / video / multimedia
    mpdscribble
    ncmpcpp
    mpd
    mpc
    nicotine-plus
    tailscale
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    pulseaudio
    sxiv
    ffmpeg
    mpv
    vlc
    easyeffects
    audacity
    reaper
    ardour
    strawberry
    spotify
    spicetify-cli

    ### games / wine / launchers
    vulkan-tools
    pcsx2
    mangohud
    gamemode
    hydralauncher
    azahar
    melonDS
    steam
    heroic
    lutris
    wine
    winetricks
    bottles
    protonup-qt

    ###  mobile / casting
    scrcpy
    droidcam
    uxplay

    ### social
    nheko
    gomuks
    element-desktop
    arrpc
    #telegram-desktop
    ferdium
    revolt-desktop

    ### productivity/notes
    libreoffice-qt
    teams-for-linux
    obsidian
    anki
    keepassxc
    xournalpp

    ### image editing
    gimp

    ### internet / downloads
    qbittorrent

    ### others
    pywal16
    appimage-run
    anydesk
    syncthing


    #themes
    adapta-gtk-theme
    fluent-gtk-theme
  ];

  #################### SERVICES ####################
  services.syncthing = {
    user = "lucas";
    openDefaultPorts = true;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  services.tailscale = {
    enable = true;
  };
  services.gnome.gnome-keyring.enable = true;

  #################### FONTS ####################
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
  ];
    ############################################
  # Enable D-Bus (required for GVFS to work)
  ############################################
  services.dbus.enable = true;

  ############################################
  # Enable udisks2 (handles disk mounting)
  ############################################
  services.udisks2.enable = true;

  ############################################
  # Enable GVFS (backend for Nautilus mounts)
  ############################################
  services.gvfs.enable = true;

  ############################################
  # Enable usbmuxd (required for iPhone support)
  ############################################
  services.usbmuxd.enable = true;

  #################### VPN ####################
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  #################### NIX ####################
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";
}

