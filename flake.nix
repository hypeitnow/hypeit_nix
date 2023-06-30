{
  description = "test";
  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
    home-manager.url = "flake:home-manager";
  };
  outputs = inputs:
    let
      flakeContext = {
        inherit inputs;
      };
    in
    {
      homeConfigurations = {
        nixos = import ./homeConfigurations/nixos.nix flakeContext;
      };
      nixosConfigurations = {
        nixos = import ./nixosConfigurations/nixos.nix flakeContext;
      };
    };
}
