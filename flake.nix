{
  description = "A reproducible package set for Cosmos";

  inputs = {
    # Nix Inputs
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;
    rust-overlay.url = github:oxalica/rust-overlay;
    pre-commit-hooks.url = github:cachix/pre-commit-hooks.nix;
    # Has to follow flake-utils in order to get aarch64-darwin
    # can revert after https://github.com/cachix/pre-commit-hooks.nix/pull/142
    pre-commit-hooks.inputs.flake-utils.follows = "flake-utils";

    # Freshautomations inputs
    stoml-src.url = github:freshautomations/stoml;
    stoml-src.flake = false;

    sconfig-src.url = github:freshautomations/sconfig;
    sconfig-src.flake = false;

    # Relayer Sources
    ibc-rs-src.url = github:informalsystems/ibc-rs/v0.13.0-rc.0;
    ibc-rs-src.flake = false;

    ts-relayer-src.url = github:confio/ts-relayer/v0.4.0;
    ts-relayer-src.flake = false;

    relayer-src.url = github:cosmos/relayer/v1.0.0;
    relayer-src.flake = false;

    ica-src.flake = false;
    ica-src.url = github:cosmos/interchain-accounts-demo;

    # Chain Sources
    gaia7-src.flake = false;
    gaia7-src.url = github:cosmos/gaia/v7.0.0-rc0;

    gaia6_0_2-src.flake = false;
    gaia6_0_2-src.url = github:cosmos/gaia/v6.0.2;

    gaia6_0_3-src.flake = false;
    gaia6_0_3-src.url = github:cosmos/gaia/v6.0.3;

    gaia6-ordered-src.flake = false;
    gaia6-ordered-src.url = github:informalsystems/gaia/v6.0.4-ordered;

    gaia6_0_4-src.flake = false;
    gaia6_0_4-src.url = github:cosmos/gaia/v6.0.4;

    gaia5-src.flake = false;
    gaia5-src.url = github:cosmos/gaia/v5.0.8;

    ibc-go-v2-src.flake = false;
    ibc-go-v2-src.url = github:cosmos/ibc-go/v2.2.0;

    ibc-go-v3-src.flake = false;
    ibc-go-v3-src.url = github:cosmos/ibc-go/v3.0.0;

    ibc-go-ics29-src.flake = false;
    ibc-go-ics29-src.url = github:cosmos/ibc-go/ics29-fee-middleware;

    cosmos-sdk-src.flake = false;
    cosmos-sdk-src.url = github:cosmos/cosmos-sdk/v0.45.0-rc1;

    iris-src.flake = false;
    iris-src.url = github:irisnet/irishub/v1.1.1;

    regen-src.flake = false;
    regen-src.url = github:regen-network/regen-ledger/v3.0.0;

    evmos-src.flake = false;
    evmos-src.url = github:tharsis/evmos/v3.0.0-beta;

    juno-src.flake = false;
    juno-src.url = github:CosmosContracts/juno/v2.3.0-beta.2;

    osmosis-src.flake = false;
    osmosis-src.url = github:osmosis-labs/osmosis/v7.0.4;

    terra-src.flake = false;
    terra-src.url = github:terra-money/core/v0.5.17;

    wasmvm_1_beta7-src.flake = false;
    wasmvm_1_beta7-src.url = github:CosmWasm/wasmvm/v1.0.0-beta7;

    wasmvm_0_16_3-src.flake = false;
    wasmvm_0_16_3-src.url = github:CosmWasm/wasmvm/v0.16.3;
  };

  outputs = inputs:
    with inputs.flake-utils.lib;
      eachDefaultSystem (system: let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [inputs.rust-overlay.overlay];
        };
        eval-pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
        resources = (import ./resources.nix) {
          inherit inputs pkgs eval-pkgs system;
        };
        tests = (import ./tests.nix) {
          inherit (resources) packages;
          inherit pkgs system;
        };
      in rec {
        # nix build .#<app>
        packages = flattenTree (resources.packages // resources.devShells // tests);

        # nix flake check
        checks = (import ./checks.nix) {
          inherit inputs system;
          packages = resources.packages;
        };

        # nix develop
        devShell = resources.devShells.nix-shell;

        # nix run .#<app>
        apps = {
          hermes = mkApp {
            name = "hermes";
            drv = packages.hermes;
          };
          gaia = mkApp {
            name = "gaia";
            drv = packages.gaia6_0_3;
            exePath = "/bin/gaiad";
          };
          gaia4 = mkApp {
            name = "gaia";
            drv = packages.gaia4;
            exePath = "/bin/gaiad";
          };
          gaia5 = mkApp {
            name = "gaia";
            drv = packages.gaia5;
            exePath = "/bin/gaiad";
          };
          gaia6 = mkApp {
            name = "gaia";
            drv = packages.gaia6_0_4;
            exePath = "/bin/gaiad";
          };
          gaia6_0_2 = mkApp {
            name = "gaia";
            drv = packages.gaia6_0_2;
            exePath = "/bin/gaiad";
          };
          gaia6_0_3 = mkApp {
            name = "gaia";
            drv = packages.gaia6_0_3;
            exePath = "/bin/gaiad";
          };
          gaia6_0_4 = mkApp {
            name = "gaia";
            drv = packages.gaia6_0_4;
            exePath = "/bin/gaiad";
          };
          gaia6-ordered = mkApp {
            name = "gaia";
            drv = packages.gaia6-ordered;
            exePath = "/bin/gaiad";
          };
          gaia7 = mkApp {
            name = "gaia";
            drv = packages.gaia7;
            exePath = "/bin/gaiad";
          };
          ica = mkApp {
            name = "icad";
            drv = packages.ica;
            exePath = "/bin/icad";
          };
          cosmovisor = mkApp {
            name = "cosmovisor";
            drv = packages.cosmovisor;
          };
          simd = mkApp {
            name = "simd";
            drv = packages.simd;
          };
          stoml = mkApp {
            name = "stoml";
            drv = packages.stoml;
          };
          sconfig = mkApp {
            name = "sconfig";
            drv = packages.sconfig;
          };
          gm = mkApp {
            name = "gm";
            drv = packages.gm;
          };
          osmosis = mkApp {
            name = "osmosis";
            drv = packages.osmosis;
            exePath = "/bin/osmosisd";
          };
          iris = mkApp {
            name = "iris";
            drv = packages.iris;
          };
          regen = mkApp {
            name = "regen";
            drv = packages.regen;
          };
          evmos = mkApp {
            name = "evmos";
            drv = packages.evmos;
            exePath = "/bin/evmosd";
          };
          ts-relayer = mkApp {
            name = "ts-relayer";
            drv = packages.ts-relayer;
          };
          ts-relayer-setup = mkApp {
            name = "ts-relayer-setup";
            drv = packages.ts-relayer-setup;
          };
          juno = mkApp {
            name = "juno";
            drv = packages.juno;
            exePath = "/bin/junod";
          };
          terra = mkApp {
            name = "terra";
            drv = packages.terra;
            exePath = "/bin/terrad";
          };
        };
      });
}
