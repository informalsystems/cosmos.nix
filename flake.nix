{
  description = "A reproducible package set for Cosmos";

  inputs = {
    # Nix Inputs
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;
    rust-overlay.url = github:oxalica/rust-overlay;
    pre-commit-hooks.url = github:cachix/pre-commit-hooks.nix;
    sbt-derivation.url = github:zaninime/sbt-derivation;
    nix-std.url = github:chessai/nix-std;

    # Has to follow flake-utils in order to get aarch64-darwin
    # can revert after https://github.com/cachix/pre-commit-hooks.nix/pull/142
    pre-commit-hooks.inputs.flake-utils.follows = "flake-utils";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

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

    gaia-main-src.flake = false;
    gaia-main-src.url = github:cosmos/gaia;

    gaia7-src.flake = false;
    gaia7-src.url = github:cosmos/gaia/v7.0.3;

    gaia6-ordered-src.flake = false;
    gaia6-ordered-src.url = github:informalsystems/gaia/v6.0.4-ordered;

    gaia6-src.flake = false;
    gaia6-src.url = github:cosmos/gaia/v6.0.4;

    gaia5-src.flake = false;
    gaia5-src.url = github:cosmos/gaia/v5.0.8;

    ibc-go-v2-src.flake = false;
    ibc-go-v2-src.url = github:cosmos/ibc-go/v2.4.1;

    ibc-go-v3-src.flake = false;
    ibc-go-v3-src.url = github:cosmos/ibc-go/v3.3.0;

    ibc-go-v4-src.flake = false;
    ibc-go-v4-src.url = github:cosmos/ibc-go/v4.1.0;

    ibc-go-v5-src.flake = false;
    ibc-go-v5-src.url = github:cosmos/ibc-go/v5.0.0;

    cosmos-sdk-src.flake = false;
    cosmos-sdk-src.url = github:cosmos/cosmos-sdk/v0.46.0;

    iris-src.flake = false;
    iris-src.url = github:irisnet/irishub/v1.1.1;

    regen-src.flake = false;
    regen-src.url = github:regen-network/regen-ledger/v3.0.0;

    evmos-src.flake = false;
    evmos-src.url = github:tharsis/evmos/v6.0.2;

    juno-src.flake = false;
    juno-src.url = github:CosmosContracts/juno/v2.3.0-beta.2;

    osmosis-src.flake = false;
    osmosis-src.url = github:osmosis-labs/osmosis/v12.1.0;

    osmosis7-src.flake = false;
    osmosis7-src.url = github:osmosis-labs/osmosis/v7.3.0;

    osmosis6-src.flake = false;
    osmosis6-src.url = github:osmosis-labs/osmosis/v6.4.1;

    osmosis8-src.flake = false;
    osmosis8-src.url = github:osmosis-labs/osmosis/v8.0.0;

    terra-src.flake = false;
    terra-src.url = github:terra-money/core/v0.5.17;

    sentinel-src.flake = false;
    sentinel-src.url = github:sentinel-official/hub/v0.9.0-rc0;

    akash-src.flake = false;
    akash-src.url = github:ovrclk/akash/v0.15.0-rc17;

    umee-src.flake = false;
    umee-src.url = github:umee-network/umee/v2.0.0;

    ixo-src.flake = false;
    ixo-src.url = github:ixofoundation/ixo-blockchain/v0.18.0-rc1;

    sifchain-src.flake = false;
    sifchain-src.url = github:Sifchain/sifnode/v0.12.1;

    crescent-src.flake = false;
    crescent-src.url = github:crescent-network/crescent/v1.0.0-rc3;

    stargaze-src.flake = false;
    stargaze-src.url = github:public-awesome/stargaze/v3.0.0;

    wasmd-src.flake = false;
    wasmd-src.url = github:CosmWasm/wasmd/v0.27.0;

    wasmvm_1-src.flake = false;
    wasmvm_1-src.url = github:CosmWasm/wasmvm/v1.0.0;

    wasmvm_1_beta7-src.flake = false;
    wasmvm_1_beta7-src.url = github:CosmWasm/wasmvm/v1.0.0-beta7;

    wasmvm_0_16_3-src.flake = false;
    wasmvm_0_16_3-src.url = github:CosmWasm/wasmvm/v0.16.3;

    apalache-src.flake = false;
    apalache-src.url = github:informalsystems/apalache/v0.24.0;

    ignite-cli-src.flake = false;
    ignite-cli-src.url = github:ignite/cli/v0.24.0;
  };

  outputs = inputs:
    with inputs.flake-utils.lib;
      eachSystem
      [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ]
      (system: let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.rust-overlay.overlay
            inputs.sbt-derivation.overlay
          ];
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
        devShells = resources.devShells;

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
            drv = packages.gaia6;
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
          gaia-main = mkApp {
            name = "gaia";
            drv = packages.gaia-main;
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
          ignite-cli = mkApp {
            name = "ignite-cli";
            exePath = "/bin/ignite";
            drv = packages.ignite-cli;
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
          osmosis7 = mkApp {
            name = "osmosis";
            drv = packages.osmosis7;
            exePath = "/bin/osmosisd";
          };
          osmosis6 = mkApp {
            name = "osmosis";
            drv = packages.osmosis6;
            exePath = "/bin/osmosisd";
          };
          osmosis8 = mkApp {
            name = "osmosis";
            drv = packages.osmosis8;
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
          sentinel = mkApp {
            name = "sentinel";
            drv = packages.sentinel;
            exePath = "/bin/sentinelhub";
          };
          akash = mkApp {
            name = "akash";
            drv = packages.akash;
          };
          umee = mkApp {
            name = "umee";
            drv = packages.umee;
            exePath = "/bin/umeed";
          };
          ixo = mkApp {
            name = "ixo";
            drv = packages.ixo;
            exePath = "/bin/ixod";
          };
          sifchain = mkApp {
            name = "sifchain";
            drv = packages.sifchain;
            exePath = "/bin/sifnoded";
          };
          crescent = mkApp {
            name = "crescent";
            drv = packages.crescent;
            exePath = "/bin/crescentd";
          };
          stargaze = mkApp {
            name = "stargaze";
            drv = packages.stargaze;
            exePath = "/bin/starsd";
          };
          wasmd = mkApp {
            name = "wasmd";
            drv = packages.wasmd;
          };
          apalache = mkApp {
            name = "apalache";
            drv = packages.apalache;
            exePath = "/bin/apalache-mc";
          };
        };
      });
}
