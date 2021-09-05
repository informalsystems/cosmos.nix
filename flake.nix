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

    # Freshautomations inputs
    stoml-src = {
      url = github:freshautomations/stoml;
      flake = false;
    };

    sconfig-src = {
      url = github:freshautomations/sconfig;
      flake = false;
    };

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
    , stoml-src
    , sconfig-src
    , ibc-rs-src
    , tendermint-rs-src
    , gaia-src
    , cosmos-sdk-src
    , ibc-go-src
    }:
    let
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
    with flake-utils.lib;
    eachDefaultSystem (system:
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
        stoml = {
          inputName = "stoml-src";
          storePath = "${stoml-src}";
        };
        sconfig = {
          inputName = "sconfig-src";
          storePath = "${sconfig-src}";
        };
        gaia = {
          inputName = "gaia-src";
          storePath = "${gaia-src}";
        };
        cosmovisor = {
          inputName = "cosmos-sdk-src";
          storePath = "${cosmos-sdk-src}/cosmovisor";
        };
      };
      syncGoModulesInputs = with builtins; concatStringsSep " "
        (attrValues (builtins.mapAttrs (name: value: "${name}:${value.inputName}${value.storePath}") goProjectSrcs));
      syncGoModulesCheck = (import ./syncGoModules) { inherit pkgs syncGoModulesInputs; };
    in
    rec {
      # nix build .#<app>
      packages = flattenTree
        {
          stoml = (import ./stoml) { inherit pkgs stoml-src; };
          sconfig = (import ./sconfig) { inherit pkgs sconfig-src; };
          gm = (import ./gm) { inherit pkgs ibc-rs-src; };
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
        };

      # nix flake check
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            nix-linter.enable = true;
            sync-go-modules = with builtins;
              {
                enable = true;
                name = "sync-go-modules";
                entry = "${syncGoModulesCheck}/bin/syncGoModulesCheck -l";
                files = "(\\.(lock|narHash)|flake.nix)$";
                language = "system";
                pass_filenames = false;
              };
          };
        };
      };

      # nix develop
      devShell =
        let
          syncGoModulesInputs = with builtins; concatStringsSep " "
            (attrValues (builtins.mapAttrs (name: value: "${name}:${value.inputName}${value.storePath}") goProjectSrcs));
          syncGoModulesScript = pkgs.writeShellScriptBin "syncGoModules" ''
            echo "${syncGoModulesInputs}" | ./syncGoModules/syncGoModules.hs
          '';
        in
        pkgs.mkShell {
          shellHook = self.checks.${system}.pre-commit-check.shellHook;
          nativeBuildInputs = with pkgs; [
            rustc
            cargo
            pkg-config
          ];
          buildInputs = with pkgs; [
            # need to prefix with pkgs because of they shadow the name of inputs
            pkgs.crate2nix
            pkgs.gomod2nix

            openssl
            syncGoModulesScript

            # gaia manager dependencies
            packages.stoml
            packages.sconfig
            pkgs.gnused
          ];
        };

      # nix run .#<app>
      apps = {
        hermes = mkApp { name = "hermes"; drv = packages.hermes; };
        gaia = mkApp { name = "gaia"; drv = packages.gaia; exePath = "/bin/gaiad"; };
        cosmovisor = mkApp { name = "cosmovisor"; drv = packages.cosmovisor; };
        stoml = mkApp { name = "stoml"; drv = packages.stoml; };
        sconfig = mkApp { name = "sconfig"; drv = packages.sconfig; };
        gm = mkApp { name = "gm"; drv = packages.gm; };
      };
    });
}
