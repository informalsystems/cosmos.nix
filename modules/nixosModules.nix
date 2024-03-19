{
  inputs,
  hermes,
  ...
}: let
  std = inputs.nix-std;
in {
  flake.nixosModules = {
    hermes = import ../../nixosModules/hermes/default.nix {inherit nix-std hermes;};
  };
}
