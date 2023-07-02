{ pkgs, lib, ... }:

{
  # enable the Roland RC-505 as an ALSA device

  # pin the kernel so we don't need to keep building it
  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_1.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
        sha256 = "sha256-6GkXu6GZDpZ5Q2RUhBgqZLoyX5ixFKGQbMHVCZLgc8E=";
      };
      version = "6.1.31";
      modDirVersion = "6.1.31";
    };
  });

}
