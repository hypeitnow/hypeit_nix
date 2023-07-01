{
  pkgs,
  config,
  ...
}:
# media - control and enjoy audio/video
let
  hm = fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
in
{
  imports = [ (import "${hm}/nixos") ];
  home.packages = with pkgs; [
    # audio control
    pavucontrol
    playerctl
    pulsemixer
    # images
    imv
    vlc
    torrential 
  ];

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      scripts = [pkgs.mpvScripts.mpris];
    };
    obs-studio.enable = true;
  };

  services = {
    playerctld.enable = true;
  };
}
