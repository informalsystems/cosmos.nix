{
  description = "A reproducible package set for Cosmos";

  inputs = {
    # Nix Inputs
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;
    rust-overlay.url = github:oxalica/rust-overlay;
    pre-commit-hooks.url = github:cachix/pre-commit-hooks.nix;

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

    gaia6_0_4-src.flake = false;
    gaia6_0_4-src.url = github:cosmos/gaia/v6.0.4;

    gaia5-src.flake = false;
    gaia5-src.url = github:cosmos/gaia/v5.0.8;

    gaia4-src.flake = false;
    gaia4-src.url = github:cosmos/gaia/v4.2.1;

    cosmos-sdk-src.flake = false;
    cosmos-sdk-src.url = github:cosmos/cosmos-sdk/v0.45.0-rc1;

    osmosis-src.flake = false;
    osmosis-src.url = github:osmosis-labs/osmosis/v6.1.0;

    iris-src.flake = false;
    iris-src.url = github:irisnet/irishub/v1.1.1;

    regen-src.flake = false;
    regen-src.url = github:regen-network/regen-ledger/v2.1.0;

    evmos-src.flake = false;
    evmos-src.url = github:tharsis/evmos/v0.4.2;

    # Issue with replace directive for edwards in dcred dependency
    # thor-src.flake = false;
    # thor-src.url = gitlab:thorchain/thornode/v0.77.2;

    # Issue with dynamically linked libwasmvm, need to figure out how to
    # inject the dependency statically using musl
    # juno-src.flake = false;
    # juno-src.url = github:CosmosContracts/juno/v2.1.0;
  };

  outputs = inputs:
    with inputs.flake-utils.lib;
    eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.rust-overlay.overlay ];
        };
        eval-pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
        resources = (import ./resources.nix) { inherit inputs pkgs eval-pkgs system; };
        tests = (import ./tests.nix) { inherit (resources) packages; inherit pkgs system; };
      in
      rec {

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
          hermes = mkApp { name = "hermes"; drv = packages.hermes; };
          gaia = mkApp { name = "gaia"; drv = packages.gaia6_0_3; exePath = "/bin/gaiad"; };
          gaia4 = mkApp { name = "gaia"; drv = packages.gaia4; exePath = "/bin/gaiad"; };
          gaia5 = mkApp { name = "gaia"; drv = packages.gaia5; exePath = "/bin/gaiad"; };
          gaia6 = mkApp { name = "gaia"; drv = packages.gaia6_0_4; exePath = "/bin/gaiad"; };
          gaia6_0_2 = mkApp { name = "gaia"; drv = packages.gaia6_0_2; exePath = "/bin/gaiad"; };
          gaia6_0_3 = mkApp { name = "gaia"; drv = packages.gaia6_0_3; exePath = "/bin/gaiad"; };
          gaia6_0_4 = mkApp { name = "gaia"; drv = packages.gaia6_0_4; exePath = "/bin/gaiad"; };
          gaia7 = mkApp { name = "gaia"; drv = packages.gaia7; exePath = "/bin/gaiad"; };
          ica = mkApp { name = "icad"; drv = packages.ica; exePath = "/bin/icad"; };
          cosmovisor = mkApp { name = "cosmovisor"; drv = packages.cosmovisor; };
          simd = mkApp { name = "simd"; drv = packages.simd; };
          stoml = mkApp { name = "stoml"; drv = packages.stoml; };
          sconfig = mkApp { name = "sconfig"; drv = packages.sconfig; };
          gm = mkApp { name = "gm"; drv = packages.gm; };
          osmosis = mkApp { name = "osmosis"; drv = packages.osmosis; exePath = "/bin/osmosisd"; };
          iris = mkApp { name = "iris"; drv = packages.iris; };
          regen = mkApp { name = "regen"; drv = packages.regen; };
          evmos = mkApp { name = "evmos"; drv = packages.evmos; exePath = "/bin/evmosd"; };
          ts-relayer = mkApp { name = "ts-relayer"; drv = packages.ts-relayer; };
          ts-relayer-setup = mkApp { name = "ts-relayer-setup"; drv = packages.ts-relayer-setup; };
          # bifrost = mkApp { name = "thor"; drv = packages.thor; exePath = "/bin/bifrost"; };
          # thorcli = mkApp { name = "thor"; drv = packages.thor; exePath = "/bin/thorcli"; };
          # thord = mkApp { name = "thor"; drv = packages.thor; exePath = "/bin/thord"; };
          # juno = mkApp { name = "juno"; drv = packages.juno; exePath = "/bin/junod"; };
        };
      });
}
