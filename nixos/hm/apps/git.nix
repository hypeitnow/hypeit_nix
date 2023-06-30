{
  pkgs,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;

    userName = "hypeit";
    userEmail = "matkoz111@gmail.com";
  };
}
