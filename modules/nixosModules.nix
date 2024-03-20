{
  inputs,
  pkgs,
  ...
}: {
  flake.nixosModules = {
    hermes = import ../../nixosModules/hermes/default.nix {
      inherit (inputs) nix-std; 
      inherit (pkgs) hermes;
    };
  };
}
