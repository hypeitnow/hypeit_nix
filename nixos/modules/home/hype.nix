{ config, pkgs, ... }:

let
  hm = fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
in {

  nix.extraOptions = ''
    trusted-users = root hypeit
  '';

  # Define a user account.
  users.users.hypeit = {
    isNormalUser = true;
    initialPassword = "download";
    extraGroups =
      [ "wheel" "networkmanager" "audio" "docker" "nixconfig" "dialout" ];
  };
  #Autologin
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "hypeit";

  programs.home-manager.enable = true;
  home-manager.users.hypeit = { pkgs, config, ... }: {

    home.packages = with pkgs; [ keybase-gui ];
    home.stateVersion = "23.05";
    home.username = "hypeit";
    home.homeDirectory = "/home/hypeit";

    home.file.".p10k.zsh" = {
      source = ./p10k/.p10k.zsh;
      executable = true;
    };
    home.file.".local/share/applications/steam.desktop" = {
      source = ./steam.desktop;
    };
    home.file.".emacs.d" = {
      source = ./emacs/.emacs.d;
      recursive = true;
    };
  };

  imports = [
    (import "${hm}/nixos")
    ./apps
  ];
}