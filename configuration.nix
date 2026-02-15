{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./uxplay.nix
  ];

  #################### BOOT ####################
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

  #################### NETWORK ####################
  networking.hostName = "lucas-nixos";
  networking.networkmanager.enable = true;
  networking.timeServers = [
    "a.st1.ntp.br"
    "b.st1.ntp.br"
    "time.cloudflare.com"
    "time.google.com"
    "pool.ntp.org"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
    allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
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

    videoDrivers = [ "nvidia" ];
  };

  #################### DISPLAY MANAGER ####################
  services.displayManager.sddm.enable = true;

  # Wayland (Plasma Wayland) — comentado pois você usa i3/X11
  # services.displayManager.sddm.wayland.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasmax11";

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

    ### 🖥️ Sistema / Monitoramento
    lm_sensors
    sysstat
    btop
    fastfetch

    ### 📦 Arquivos / Compressão
    unzip
    ntfs3g

    ### 🧰 Dev / CLI
    gcc
    cmake
    git
    gh
    neovim
    emacs

    ### 🖱️ X11 / Desktop / WM Utils
    picom
    maim
    slop
    scrot
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
    pavucontrol

    ### 🔊 Áudio / Vídeo / Multimídia
    pulseaudio
    sxiv
    ffmpeg
    mpv
    easyeffects
    audacity
    ardour
    spotify

    ### 🎮 Games / Wine / Launchers
    steam
    heroic
    lutris
    wine
    bottles

    ### 📱 Mobile / Casting
    scrcpy
    droidcam
    uxplay

    ### 💬 Comunicação / Social
    discord
    telegram-desktop
    ferdium
    revolt-desktop

    ### 📝 Produtividade / Escrita / Notas
    obsidian
    libreoffice-qt
    anki
    keepassxc
    xournalpp

    ### 🎨 Criativo / Design / Vídeo
    gimp
    davinci-resolve

    ### 🌐 Internet / Downloads
    qbittorrent
    nicotine-plus

    ### 🖥️ Outros
    appimage-run
    anydesk
    popsicle
    syncthing
  ];

  #################### SERVICES ####################
  services.syncthing = {
    user = "lucas";
    openDefaultPorts = true;
  };

  services.gnome.gnome-keyring.enable = true;

  #################### FONTS ####################
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  #################### NVIDIA ####################
  hardware.opengl.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  #################### VPN ####################
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  #################### NIX ####################
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";
}

