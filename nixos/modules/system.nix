{ config, pkgs, ... }:

{
  # imports = [ ./cachix.nix ];

  # nix stuff
  system.stateVersion = "23.05";

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    '';

  nix.settings = {
    tarball-ttl = 300;
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 2d";
  };

  # NVIDIA requires nonfree
  nixpkgs.config.allowUnfree = true;

  # Use GRUB, assume UEFI
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.splashImage = ./grub/alwaysnix.png;
  boot.loader.grub.splashMode = "stretch"; # "normal"
  boot.loader.grub.useOSProber = true;
  boot.loader.timeout = 60;
  boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];
  # copyKernels: "Using NixOS on a ZFS root file system might result in the boot error
  # external pointer tables not supported when the number of hardlinks in the nix
  # store gets very high.
  boot.loader.grub.copyKernels = true;

  networking.firewall.enable = false;

  time.timeZone = "Europe/Warsaw";

  hardware.bluetooth.enable = true;

  # desktop stuff
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps,terminate:ctrl_alt_bksp";
  services.xserver.enableCtrlAltBackspace = true;
  services.xserver.dpi = 96;
  services.xserver.libinput.enable = true; # touchpad
  fonts.fonts = with pkgs; [ ubuntu_font_family ];

  # sound
  sound.enable = true;
  #hardware.pulseaudio.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    pulse.enable = true;
  };

  # virtualization
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # printing
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # all other services
  services.fwupd.enable = true;
  services.locate.enable = true;
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "yes";
  };
  services.tlp = {
    settings = {
      # only charge up to 80% of the battery capacity
      START_CHARGE_THRESH_BAT0 = "75";
      STOP_CHARGE_THRESH_BAT0 = "80";
    };
  };
  services.fstrim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = "quarterly";
  services.zfs.trim.enable = true;

  programs.steam.enable = true;

  # enable docker
  virtualisation.docker.enable = true;

  programs.ssh = {
    pubkeyAcceptedKeyTypes = [ "ssh-ed25519" "ssh-rsa" ];
    hostKeyAlgorithms = [ "ssh-ed25519" "ssh-rsa" ];
  };

  users.groups.nixconfig = { };

  environment.etc."vimrc".text = ''
    " get rid of maddening mouseclick-moves-cursor behavior
    set mouse=
    set ttymouse=
  '';

  
  # List software packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim_configurable
    wget
    obs-studio
    thermald
    powertop
    libsForQt5.kdeconnect-kde
    libsForQt5.krdc
    gnome.gnome-disk-utility
    openvpn
    unzip
    ripgrep
    btop
    killall
    htop
    handbrake
    mpv
    vlc
    google-chrome
    firefox
    audacity
    gimp
    transmission-qt
    remmina
    baobab
    signal-desktop
    virtualbox
    (python310.withPackages (p:
      with p; [
        python310Packages.pyserial # for pico-w-go in vscode
        python310Packages.pyflakes # for emacs
        python310Packages.black # for cmdline and vscode
      ]))
    xz
    libreoffice
    ffmpeg-full
    iperf
    pciutils
    neofetch
    tmux
    heroic
    s-tui
    stress-ng
    usbutils
    nmap
    zoom-us
    konversation
    nixfmt
    wakeonlan
    #/nix/store/4nq5wfa01vq6x00q8k777qhf47bp2wd4-olive-editor-0.1.2
    olive-editor
    cachix
    gptfdisk # "sgdisk"
    ardour
    qjackctl
    odin2
    freepats
    helm
    distrho
    calf
    x42-plugins
    tap-plugins
    zam-plugins
    sanoid
    hplip
    geteltorito
    argyllcms
    xcalib
    virt-manager
    rpi-imager
    dig
    s3cmd
    kaffeine
    pcmanfm-qt
    thonny
    cutecom
    rshell
    mplayer
    vscode
    gnome.cheese
    sqlite
  ];
}
