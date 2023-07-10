{pkgs, ...}: {
  
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip

    # utils
    ripgrep
    yq-go    # https://github.com/mikefarah/yq
    htop
    git
    nano # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    sysstat
    lm_sensors  # for `sensors` command
    scrot
    nnn  
    
    # misc
    libnotify
    wineWowPackages.wayland
    xdg-utils
    graphviz

    # productivity
    obsidian
    wireshark
    kitty

    # IDE
    insomnia

    # cloud native
    docker-compose
    kubectl


    nodejs
    nodePackages.npm
    nodePackages.pnpm
    yarn

    # db related
    dbeaver
    mycli
    pgcli
    #ZSH
    zsh-autocomplete
    zsh
    autojump
    
  ];

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = "mouse on";
    };

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "Catppuccin-mocha";
      };
      themes = {
        Catppuccin-mocha = builtins.readFile (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-mocha.tmTheme";
          hash = "sha256-qMQNJGZImmjrqzy7IiEkY5IhvPAMZpq0W6skLLsng/w=";
        });
      };
    };

    skim = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files --hidden";
      changeDirWidgetOptions = [
        "--preview 'exa --icons --git --color always -T -L 3 {} | head -200'"
        "--exact"
      ];
    };

    btop.enable = true;  # replacement of htop/nmon
    exa.enable = true;   # A modern replacement for ‘ls’
    jq.enable = true;    # A lightweight and flexible command-line JSON processor
    ssh.enable = true;
    aria2.enable = true;

    emacs.enable = true;
    emacs.extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.flycheck
      epkgs.json-mode
      epkgs.python-mode
      epkgs.auto-complete
      epkgs.web-mode
      epkgs.smart-tabs-mode
      epkgs.whitespace-cleanup-mode
      epkgs.flycheck-pyflakes
    ];
  };

  services = {
    syncthing.enable = true;
    # auto mount usb drives
    udiskie.enable = true;
    emacs.enable = true;
  };

}
