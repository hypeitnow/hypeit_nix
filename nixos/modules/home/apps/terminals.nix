{
  programs.alacritty = {
    enable = true;
  };

  xdg.configFile."alacritty/alacritty.yml".source = ./ala/alacritty.yml;
  xdg.configFile."alacritty/theme_github_dark.yml".source = ./ala/theme_github_dark.yml;
}
