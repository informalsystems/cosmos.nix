{
  description = "A reproducible Cosmos";

  inputs = {
    # Nix Inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    flake-utils.url = "github:numtide/flake-utils";

    # Rust Inputs
    rust-overlay.url = "github:oxalica/rust-overlay";
    crate2nix = {
      url = "github:yusdacra/crate2nix/feat/builtinfetchgit";
      flake = false;
    };

    # Go Inputs
    gomod2nix.url = "github:tweag/gomod2nix";

    # Cosmos Sources
    ibc-rs-src = {
      url = github:informalsystems/ibc-rs;
      flake = false;
    };

    tendermint-rs-src = {
      flake = false;
      url = github:informalsystems/tendermint-rs;
    };

    gaia-src = {
      flake = false;
      url = github:cosmos/gaia;
    };

    cosmos-sdk-src = {
      flake = false;
      url = github:cosmos/cosmos-sdk;
    };

    ibc-go-src = {
      flake = false;
      url = github:cosmos/ibc-go;
    };
  };

  outputs =
    { self
    , nixpkgs
    , pre-commit-hooks
    , flake-utils
    , rust-overlay
    , crate2nix
    , gomod2nix
    , ibc-rs-src
    , tendermint-rs-src
    , gaia-src
    , cosmos-sdk-src
    , ibc-go-src
    }:
    let
      utils = flake-utils.lib;
      overlays = [
        rust-overlay.overlay
        (final: _: {
          # Because rust-overlay bundles multiple rust packages into one
          # derivation, specify that mega-bundle here, so that crate2nix
          # will use them automatically.
          rustc = final.rust-bin.stable.latest.default;
          cargo = final.rust-bin.stable.latest.default;
        })
        gomod2nix.overlay
      ];
    in
    utils.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system overlays; };
      evalPkgs = import nixpkgs { system = "x86_64-linux"; inherit overlays; };
      # Note: below is the only use of eval pkgs. This is due to an issue with import from
      # derivation (IFD), which requires nix derivations to be built at evaluation time.
      # Since we can't build on all system types (`utils.eachDefaultSystem` requires us
      # to evaluate all possible systems) we need to pick a system for building during
      # evaluation. With proper caching this flake should still work for running on all
      # system types.
      #
      # Github Issue: https://github.com/NixOS/nix/issues/4265
      generateCargoNix = (import "${crate2nix}/tools.nix" { pkgs = evalPkgs; }).generatedCargoNix;
      goProjectSrcs = {
        gaia = { inputName = "gaia-src"; storePath = "${gaia-src}"; };
        cosmovisor = {
          inputName = "cosmos-sdk-src";
          storePath = "${cosmos-sdk-src}/cosmovisor";
        };
        ibc-go = { inputName = "ibc-go-src"; storePath = "${ibc-go-src}"; };
      };
    in
    rec {
      # nix build .#<app>
      packages = utils.flattenTree
        {
          sources = pkgs.stdenv.mkDerivation {
            name = "sources";
            unpackPhase = "true";
            buildPhase = "true";
            installPhase = ''
              mkdir -p $out
              ls -la $out
              ln -s ${tendermint-rs-src} $out/tendermint-rs
              ln -s ${gaia-src} $out/gaia
              ln -s ${cosmos-sdk-src} $out/cosmos-sdk
              ln -s ${ibc-go-src} $out/ibc-go
            '';
          };
          hermes = (import ./hermes) { inherit pkgs ibc-rs-src generateCargoNix; };
          gaia = (import ./gaia) { inherit gaia-src pkgs; };
          cosmovisor = (import ./cosmovisor) { inherit pkgs; cosmovisor-src = goProjectSrcs.cosmovisor.storePath; };
          ibc-go = (import ./ibc-go) { inherit ibc-go-src pkgs; };
        };

      # nix flake check
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            nix-linter.enable = true;
          };
        };
      };

      # nix develop
      devShell =
        let
          syncGoModulesInputs = with builtins; concatStringsSep " "
            (attrValues (builtins.mapAttrs (name: value: "${name}:${value.inputName}${value.storePath}") goProjectSrcs));
          syncGoModulesScript = pkgs.writeShellScriptBin "syncGoModules" ''
            echo "${syncGoModulesInputs}" | ./syncGoModules.hs
          '';
        in
        pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          nativeBuildInputs = with pkgs; [
            rustc
            cargo
            pkg-config
          ];
          buildInputs = with pkgs; [
            openssl
            # need to prefix with pkgs because of they shadow the name of inputs
            pkgs.crate2nix
            pkgs.gomod2nix
            syncGoModulesScript
          ];
        };

      # nix run .#<app>
      apps = {
        hermes = utils.mkApp { name = "hermes"; drv = packages.hermes; };
        gaia = utils.mkApp { name = "gaia"; drv = packages.gaia; exePath = "/bin/gaiad"; };
        cosmovisor = utils.mkApp { name = "cosmovisor"; drv = packages.cosmovisor; };
        ibc-go = utils.mkApp { name = "ibc-go"; drv = packages.ibc-go; exePath = "/bin/simd"; };
      };
    });
}
