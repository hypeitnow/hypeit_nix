{ config, pkgs, ... }:

let
  hm = fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
in {
  imports = [ (import "${hm}/nixos") ];

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
  };

  imports = [
    ./apps
  ];
}