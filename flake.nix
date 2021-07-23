{
  description = "A reproducible Cosmos";

  inputs = {
    # Nix Inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    # Rust Inputs
    flake-utils.url = "github:numtide/flake-utils";

    # Cosmos Sources
    hermes.url = "path:./hermes";
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
    , hermes
    , tendermint-rs-src
    , gaia-src
    , cosmos-sdk-src
    , ibc-go-src
    }:
    let utils = flake-utils.lib; in
    utils.eachDefaultSystem (system:
    let pkgs = import nixpkgs { inherit system; }; in
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
          hermes = hermes.packages.${system}.hermes;
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
