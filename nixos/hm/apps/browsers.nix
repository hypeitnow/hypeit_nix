{
  pkgs,
  config,
  ...
}: {

  home.packages = with pkgs; [
    brave
    firefox
  ];

  programs = {
    chromium = {
      enable = true;
      commandLineArgs = ["--enable-features=TouchpadOverscrollHistoryNavigation"];
      extensions = [
        # {id = "";}  // extension id, query from chrome web store
      ];
    };

    firefox = {
      enable = true;
      profiles.hypeit = {};
    };
  };
}
