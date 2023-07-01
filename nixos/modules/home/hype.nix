{ config, pkgs, ... }:

{

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
  # default shell for all users
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  home-manager.users.hypeit = { pkgs, config, ... }: {

    home.packages = with pkgs; [ keybase-gui ];
    home.stateVersion = "23.05";
    home.username = "hypeit";
    home.homeDirectory = "/home/hypeit";

    home.file.".p10k.zsh" = {
      source = ./apps/p10k/.p10k.zsh;
      executable = true;
    };
    home.file.".local/share/applications/steam.desktop" = {
      source = ./apps/steam.desktop;
    };
    home.file.".Pictures/wallpaper.png" = {
      source = ./../wallpapers/wallpaper.png;
    };
    home.file.".emacs.d" = {
      source = ./../apps/emacs/.emacs.d;
      recursive = true;
    };
    imports = [
      ./apps
    ];
  };
}