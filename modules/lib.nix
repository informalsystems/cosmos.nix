# This module provides the lib argument to all other modules as 'cosmosLib'.
# This provides utility functions for packaging cosmos sdk and cosmwasm packages
{inputs, ...}: let
  lib = import ../lib;
  std = inputs.nix-std;
  # overidable with with defaults
  # features
  # cargoBuild
  # install
  # binaryName
  # rust version
  # nativeBuildInputs because can need protobuf etc
  #
  # profile
  # non default must set
  # src
  # name
  # wasm-opt is hardcoded with check
  # build CW20 for example
  #   buildCosmwasmContract = name: rust: std-config: let
  #   binaryName = "${builtins.replaceStrings ["-"] ["_"] name}.wasm";
  # in
  #   rust.buildPackage (rust-attrs
  #     // {
  #       src = rust-src;
  #       pnameSuffix = "-${name}";
  #       nativeBuildInputs = [
  #         pkgs.binaryen
  #         self.inputs.cosmos.packages.${system}.cosmwasm-check
  #       ];
  #       pname = name;
  #       cargoBuildCommand = "cargo build --target wasm32-unknown-unknown --profile release --package ${name} ${std-config}";
  #       RUSTFLAGS = "-C link-arg=-s";
  #       installPhaseCommand = ''
  #         mkdir --parents $out/lib
  #         # from CosmWasm/rust-optimizer
  #         # --signext-lowering is needed to support blockchains runnning CosmWasm < 1.3. It can be removed eventually
  #         wasm-opt target/wasm32-unknown-unknown/release/${binaryName} -o $out/lib/${binaryName} -Os --signext-lowering
  #         cosmwasm-check $out/lib/${binaryName}
  #       '';
  #     });
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
