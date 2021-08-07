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

    # Cosmos Sources
    # hermes.url = "path:./hermes";
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
      ];
    in
    utils.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system overlays; };
      evalPkgs = import nixpkgs { system = "x86_64-linux"; inherit overlays; };
      # Note: below is the only use of eval pkgs. This is due to an issue with import from
      # derivation (IFD), which requires nix derivations to be built at evaluation time.
      # Since we can't build on all system types (`utils.eachDefaultSystem` requires us
      # to evaluate all possible systems) we need to pick a system for evaluation. With
      # proper caching this flake should still work for running on all system types.
      # Issue: https://github.com/NixOS/nix/issues/4265
      generateCargoNix = (import "${crate2nix}/tools.nix" { pkgs = evalPkgs; }).generatedCargoNix;
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
      devShell = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        nativeBuildInputs = with pkgs; [
          rustc
          cargo
          pkg-config
        ];
        buildInputs = with pkgs; [
          openssl
          pkgs.crate2nix
        ];
      };

      # nix run .#<app>
      apps = {
        hermes = utils.mkApp { name = "hermes"; drv = packages.hermes; };
      };
    });
}
