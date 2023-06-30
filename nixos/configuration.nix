# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ config, pkgs, ... } @args:

let
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

in

{
  #nixpkgs.config.packageOverrides = nur.repos;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>    
      ./modules/fonts.nix
      ./modules/i3.nix
      ./modules/system.nix
      ./modules/user.nix

    ];

  #Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-derivations = true
    '';
  };



  nixpkgs.overlays = import ./overlays args;

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    #grub = {
      #enable = true;
      #efiSupport = true;
      #useOSProber = true;
      #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
    #};
  };

  networking = {
    hostName = "nixos-test"; # Define your hostname.
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.

    networkmanager.enable = true;
    interfaces.enp0s8 = {
      useDHCP = false;
      ipv4.addresses = [ {
        address = "192.168.1.111";
        prefixLength = 24;
      } ];
    };
    defaultGateway = "192.168.1.1";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.hypeit = import ./hm/home.nix;
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
