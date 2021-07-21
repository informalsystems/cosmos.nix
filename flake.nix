{
  description = "A flake for building Hello World";

  inputs = {
    # Nix Inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    # Rust Inputs
    rust-overlay.url = "github:oxalica/rust-overlay";
    crate2nix = {
      url = "github:yusdacra/crate2nix/feat/builtinfetchgit";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";

    # Cosmos Sources
    ibc-rs-src = {
      flake = false;
      url = github:informalsystems/ibc-rs;
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
    , rust-overlay
    , crate2nix
    , flake-utils
    , ibc-rs-src
    , tendermint-rs-src
    , gaia-src
    , cosmos-sdk-src
    , ibc-go-src
    }:
    let utils = flake-utils.lib; in
    utils.eachDefaultSystem (system:
    let pkgs = import nixpkgs {
      inherit system;
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
    };
    in
    rec {
      packages = ## utils.flattenTree
        {
          sources = pkgs.stdenv.mkDerivation {
            name = "sources";
            unpackPhase = "true";
            buildPhase = "true";
            installPhase = ''
              mkdir -p $out
              ls -la $out
              ln -s ${ibc-rs-src} $out/ibc-rs
              ln -s ${tendermint-rs-src} $out/tendermint-rs
              ln -s ${gaia-src} $out/gaia
              ln -s ${cosmos-sdk-src} $out/cosmos-sdk
              ln -s ${ibc-go-src} $out/ibc-go
            '';
          };
          hermes = import ./hermes.nix { inherit pkgs ibc-rs-src crate2nix; };
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

      # nix build
      defaultPackage = packages.sources;

      # nix run
      apps = {
        hermes = {
          type = "app";
          program = "${packages.hermes}/bin/hermes";
        };
      };
      defaultApp = apps.hermes;
    });
}
