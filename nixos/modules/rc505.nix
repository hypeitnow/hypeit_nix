{ pkgs, lib, ... }:

{
  # enable the Roland RC-505 as an ALSA device

  # pin the kernel so we don't need to keep building it
  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_5_15.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
        sha256 = "sha256-2pJw2+ZN3x2xPHBHCVf/Z5brmW2Ge7Su19FKcOHGWnI=";
      };
      version = "5.15.94";
      modDirVersion = "5.15.94";
    };
  });

}
