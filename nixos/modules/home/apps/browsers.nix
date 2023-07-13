{
  pkgs,
  config,
  ...
}: {

  home.packages = with pkgs; [
    brave
    firefox
    thunderbird
  ];

  programs = {
    firefox = {
      enable = true;
      profiles.hypeit = {};
    };
    thunderbird = {
      enable = true;
      profiles.hypeit = {
        isDefault = true;
      };
    };
  };
}
