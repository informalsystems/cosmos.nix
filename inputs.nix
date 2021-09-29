{
  # Nix Inputs
  nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
  pre-commit-hooks.url = github:cachix/pre-commit-hooks.nix;
  flake-utils.url = github:numtide/flake-utils;

  # Rust Inputs
  naersk.url = github:nmattia/naersk;

  # Go Inputs
  gomod2nix.url = github:JonathanLorimer/gomod2nix/allow-custom-vendors;

  # Freshautomations inputs
  stoml-src.url = github:freshautomations/stoml;
  stoml-src.flake = false;

  sconfig-src.url = github:freshautomations/sconfig;
  sconfig-src.flake = false;

  # Relayer Sources
  ibc-rs-src.url = github:informalsystems/ibc-rs;
  ibc-rs-src.flake = false;

  ts-relayer-src.url = github:confio/ts-relayer;
  ts-relayer-src.flake = false;

  # Chain Sources
  gaia6-src.flake = false;
  gaia6-src.url = github:cosmos/gaia/v6.0.0-rc1;

  gaia5-src.flake = false;
  gaia5-src.url = github:cosmos/gaia/v5.0.6;

  gaia4-src.flake = false;
  gaia4-src.url = github:cosmos/gaia/v4.2.1;

  cosmos-sdk-src.flake = false;
  cosmos-sdk-src.url = github:cosmos/cosmos-sdk;

  thor-src.flake = false;
  thor-src.url = github:thorchain/thornode;

  osmosis-src.flake = false;
  osmosis-src.url = github:osmosis-labs/osmosis;

  gravity-dex-src.flake = false;
  gravity-dex-src.url = github:b-harvest/gravity-dex-backend;

  iris-src.flake = false;
  iris-src.url = github:irisnet/irishub;

  regen-src.flake = false;
  regen-src.url = github:regen-network/regen-ledger/;

  ethermint-src.flake = false;
  ethermint-src.url = github:tharsis/ethermint;

  juno-src.flake = false;
  juno-src.url = github:CosmosContracts/juno;
}
