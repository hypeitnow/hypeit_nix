{ config, pkgs, lib, ... }:

let
  hw = fetchTarball
    "https://github.com/NixOS/nixos-hardware/archive/master.tar.gz"; #hw link in case of wanting to add anoter hw profile for real machine
  hm = fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz"; #home manager
in {
  imports = [
    ./hardware-configuration.nix
    ./modules/system.nix
    ./modules/rc505.nix
    (import "${hm}/nixos")
    ./modules/home/hype.nix
  ];

  networking = {
    hostName = "hypeit-nix"; # Define your hostname.

    wireless.enable = false;  # Enables wireless support via wpa_supplicant.

    networkmanager.enable = true;
    interfaces.enp0s8 = {
      useDHCP = false;
      ipv4.addresses = [ {
        address = "192.168.1.111";
        prefixLength = 24;
      } ];
    };
    #defaultGateway = "192.168.1.1";
  };
  # silence ACPI "errors" at boot shown before NixOS stage 1 output (default is 4)
  boot.consoleLogLevel = 3;

  # why must I do this?  I have no idea.  But if I don't, swnix pauses then "fails"
  # (really just prints an error) when it switches configurations.
  systemd.services.NetworkManager-wait-online.enable = false;
  
  #services.cachix-agent.enable = true;
}
