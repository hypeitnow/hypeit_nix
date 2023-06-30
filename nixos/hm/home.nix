{ config, pkgs, ... }:

{
  imports = [

    ./fcitx5
    ./i3
    ./apps
    ./rofi
  ];

  home.username = "hypeit";
  home.homeDirectory = "/home/hypeit";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

}

