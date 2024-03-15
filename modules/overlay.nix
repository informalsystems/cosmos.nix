# Provides an overlay for other flakes to consume and get all the cosmos packages in their pkgs
# https://flake.parts/overlays.html?highlight=overlay#defining-an-overlay
{
  withSystem,
  inputs,
  self,
  ...
}: {
  # Overlay with everything
  flake.overlays.default = with self.overlays;
    inputs.nixpkgs.lib.fixedPoints.composeExtensions
    cosmosNix
    cosmosNixLib;

  # Overlay with all the cosmos.nix cosmos packages
  flake.overlays.cosmosNixPackages = final: prev:
    withSystem prev.stdenv.hostPlatform.system ({self', ...}: self'.packages);

  # Overlay with the cosmos.nix nix lib (comes with a bunch of utility functions for packaging cosmos packages)
  flake.overlays.cosmosNixLib = final: prev:
    withSystem prev.stdenv.hostPlatform.system ({
      self',
      pkgs,
      ...
    }: {
      cosmosLib = let
        lib = import ../lib;
        std = inputs.nix-std;
      in
        lib std {
          inherit pkgs;
          inherit (self'.packages) cosmwasm-check;
        };
    });
}
