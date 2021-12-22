{
  description = "A reproducible package set for Cosmos";

  inputs = {
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

    relayer-src.url = github:cosmos/relayer;
    relayer-src.flake = false;

    # Chain Sources
    gaia6-src.flake = false;
    gaia6-src.url = github:cosmos/gaia/v6.0.0;

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
  };

  outputs = inputs:
    with inputs.flake-utils.lib;
    eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.gomod2nix.overlay ];
        };
        eval-pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
        resources = (import ./resources.nix) { inherit inputs pkgs eval-pkgs system; };
      in
      rec {

        # nix build .#<app>
        packages = flattenTree (resources.packages // resources.devShells);

        # nix flake check
        checks = (import ./checks.nix) {
          inherit inputs pkgs system;
          packages = resources.packages;
        };

        # nix develop
        devShell = resources.devShells.nix-shell;

        # nix run .#<app>
        apps = {
          hermes = mkApp { name = "hermes"; drv = packages.hermes; };
          gaia = mkApp { name = "gaia"; drv = packages.gaia5; exePath = "/bin/gaiad"; };
          gaia4 = mkApp { name = "gaia"; drv = packages.gaia4; exePath = "/bin/gaiad"; };
          gaia5 = mkApp { name = "gaia"; drv = packages.gaia5; exePath = "/bin/gaiad"; };
          gaia6 = mkApp { name = "gaia"; drv = packages.gaia6; exePath = "/bin/gaiad"; };
          cosmovisor = mkApp { name = "cosmovisor"; drv = packages.cosmovisor; };
          simd = mkApp { name = "simd"; drv = packages.cosmos-sdk; };
          stoml = mkApp { name = "stoml"; drv = packages.stoml; };
          sconfig = mkApp { name = "sconfig"; drv = packages.sconfig; };
          gm = mkApp { name = "gm"; drv = packages.gm; };
          bifrost = mkApp { name = "thor"; drv = packages.thor; exePath = "/bin/bifrost"; };
          thorcli = mkApp { name = "thor"; drv = packages.thor; exePath = "/bin/thorcli"; };
          thord = mkApp { name = "thor"; drv = packages.thor; exePath = "/bin/thord"; };
          osmosis = mkApp { name = "osmosis"; drv = packages.osmosis; exePath = "/bin/osmosisd"; };
          gdex = mkApp { name = "gdex"; drv = packages.gravity-dex; };
          iris = mkApp { name = "iris"; drv = packages.iris; };
          regen = mkApp { name = "regen"; drv = packages.regen; };
          ethermint = mkApp { name = "ethermint"; drv = packages.ethermint; exePath = "/bin/ethermintd"; };
          juno = mkApp { name = "juno"; drv = packages.juno; exePath = "/bin/junod"; };
          ts-relayer = mkApp { name = "ts-relayer"; drv = packages.ts-relayer; };
          ts-relayer-setup = mkApp { name = "ts-relayer-setup"; drv = packages.ts-relayer-setup; };
        };
      });
}
