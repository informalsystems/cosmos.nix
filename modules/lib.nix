# This module provides the lib argument to all other modules as 'cosmosLib'.
# This provides utility functions for packaging cosmos sdk and cosmwasm packages
{inputs, ...}: let
  lib = import ../lib;
  std = inputs.nix-std;
in {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    _module.args.cosmosLib = lib std pkgs;
  };
  flake.lib = lib std;
}
