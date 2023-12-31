{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./browsers.nix
    ./common.nix
    ./git.nix
    ./media.nix
    ./vscode.nix
    ./xdg.nix
    ./zsh.nix
    ./micro.nix
    ./terminals.nix
  ];
}
