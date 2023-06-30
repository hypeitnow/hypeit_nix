{
  programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        enableSyntaxHighlighting = true;
        autocd = true;
        defaultKeymap = "viins";
        dotDir = ".config/zsh";
        history = rec {
          size = 1000000;
          save = size;
          path = "$XDG_DATA_HOME/zsh/zsh_history";
        };
        shellAliases = {
          "ls" = "ls -l --color=auto";
          "la" = "ls -la --color=auto";
          "rmdir" = "rm -r";
          "srmdir" = "sudo rm -r";
          "mkexe" = "chmod +x";
          "smkexe" = "sudo chmod +x";
          "open" = "$EDITOR";
          "sopen" = "sudo $EDITOR";
        };
        oh-my-zsh = {
          enable = true;
          plugins = [ "docker-compose" "docker" "jsontools" "vscode" "web-search" "tig" "git" "kubectl" "gitfast" "colored-man-pages" "colorize" "cp" "sudo" "autojump" ];
          theme = "jonathan";
        };
        initExtra = ''
          bindkey '^f' autosuggest-accept
          autoload -U promptinit; promptinit

          # turn on git stash status
          zstyle :prompt:pure:git:stash show yes

        '';

  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.autojump.enable = true;
}

