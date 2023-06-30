{ config, pkgs, ... }:
let
  nixos-conf-editor = import (pkgs.fetchFromGitHub {
    owner = "vlinkz";
    repo = "nixos-conf-editor";
    rev = "0.1.1";
    sha256 = "sha256-TeDpfaIRoDg01FIP8JZIS7RsGok/Z24Y3Kf+PuKt6K4=";
  }) {};
in
{
  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.0.7"  # required by wechat-uos, and it's already EOL
    "openssl-1.1.1t"   # OpenSSL 1.1 is reaching its end of life on 2023/09/11
  ];
 # enable flakes globally
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;


  # all fonts are linked to /nix/var/nix/profiles/system/sw/share/X11/fonts
  fonts = {
    # use fonts specified by user rather than default ones
    enableDefaultFonts = false;
    fontDir.enable = true;

    fonts = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      # Noto 系列字体是 Google 主导的，名字的含义是「没有豆腐」（no tofu），因为缺字时显示的方框或者方框被叫作 tofu
      # Noto 系列字族名只支持英文，命名规则是 Noto + Sans 或 Serif + 文字名称。
      # 其中汉字部分叫 Noto Sans/Serif CJK SC/TC/HK/JP/KR，最后一个词是地区变种。
      noto-fonts        # 大部分文字的常见样式，不包含汉字
      noto-fonts-cjk    # 汉字部分
      noto-fonts-emoji  # 彩色的表情符号字体
      noto-fonts-extra  # 提供额外的字重和宽度变种

      # 思源系列字体是 Adobe 主导的。其中汉字部分被称为「思源黑体」和「思源宋体」，是由 Adobe + Google 共同开发的
      source-sans       # 无衬线字体，不含汉字。字族名叫 Source Sans 3 和 Source Sans Pro，以及带字重的变体，加上 Source Sans 3 VF
      source-serif      # 衬线字体，不含汉字。字族名叫 Source Code Pro，以及带字重的变体
      source-han-sans   # 思源黑体
      source-han-serif  # 思源宋体

      # nerdfonts
      (nerdfonts.override { fonts = [
        "FiraCode"
        "JetBrainsMono"
        "Iosevka"
      ];})

      (pkgs.callPackage ../fonts/icomoon-feather-icon-font.nix { })

      # arch linux icon, used temporarily in waybar
      (pkgs.callPackage ../fonts/archcraft-icon-font.nix { })

    ];

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Noto Color Emoji" ];
      sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  programs.dconf.enable = true;
  xdg.portal.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";         # disable root login
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "hypeit";
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git      # used by nix flakes
    git-lfs  # used by huggingface models

    # networking tools
    ethtool
    iperf3
    nmap
    socat

    # system tools
    sysstat
    lm_sensors  # for `sensors` command

    # misc
    findutils 
    file
    which
    tree
    gnused
    gnutar
    gawk
    p7zip
    xz
    zstd
    cifs-utils  # for mounting windows shares

    (python3.withPackages(ps: with ps; [
      ipython
      pandas
      requests
      pyquery
    ]))

    # need to run `conda-install` before using it
    # need to run `conda-shell` before using command `conda`
    conda

    # video/audio tools
    libva-utils
    nvtop
    vdpauinfo
    vulkan-tools
    glxinfo
    glmark2

    # minimal screen capture tool, used by i3 blur lock to take a screenshot
    # print screen key is also bound to this tool in i3 config
    scrot

    neofetch
    xfce.thunar  # xfce4's file manager
    nnn          # terminal file manager
    xdg-user-dirs

    # embedded development
    minicom

    # remote desktop(rdp connect)
    remmina
    freerdp  # required by remmina

    nixos-conf-editor
    ((pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: {
      src = (builtins.fetchTarball {
        url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
        # you need to update this sha256 every time you update vscode insiders
        # the latest sha256 is printed in the error message of `sudo nixos-rebuild switch`
        sha256 = "sha256:1dbh4i60k6dm2d07dbqakygnbf09z0s0ra0cq2b2jwqnwmzz1lrn";
      });
      version = "latest";
    }))

    (import (fetchTarball https://github.com/cachix/devenv/archive/v0.6.3.tar.gz)).default
  ];

  # replace default editor with vim
  environment.variables.EDITOR = "nano";
  
  # ZSH 
  environment.sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";
  environment.pathsToLink = ["/share/zsh"];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  # security with polkit
  services.power-profiles-daemon = {
    enable = true;
  };
  security.polkit.enable = true;
  # security with gnome-kering
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.sudo.wheelNeedsPassword = false;
  services = {
    dbus.packages = [ pkgs.gcr ];

    geoclue2.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    udev.packages = with pkgs; [ 
      gnome.gnome-settings-daemon
      platformio  # udev rules for platformio
      android-udev-rules
    ];
  };
  # Enable the X11 windowing system.
  services.flatpak.enable = true;

  # android development tools, this will install adb/fastboot and other android tools and udev rules
  # see https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/adb.nix
  programs.adb.enable = true;
  programs.zsh.enable = true;
}
