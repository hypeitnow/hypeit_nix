{config, pkgs, ...}:

{
users.users.hypeit = {
    isNormalUser = true;
    description = "hypeit";
    extraGroups = [ "users" "sudo"  "networkmanager" "wheel" "docker" "wireshark" "adbusers" ];
    shell = pkgs.zsh;
  };
  users.defaultUserShell = pkgs.zsh;
}