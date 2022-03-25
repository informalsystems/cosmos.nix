{
  system,
  inputs,
  pkgs,
  eval-pkgs,
}: let
  cleanSourceWithRegexes = src: regexes:
    with pkgs.lib;
    with builtins;
      cleanSourceWith {
        filter = (
          path: _:
            all (r: match r path == null) regexes
        );
        inherit src;
      };

  gaia-packages = import ./resources/gaia {
    inherit pkgs inputs;
  };

  ibc-packages = import ./resources/ibc-go {
    inherit pkgs inputs;
  };

  mkCosmosGoApp = (import ./resources/utilities.nix {inherit pkgs;}).mkCosmosGoApp;

  # Cosmos packages
  packages = with inputs;
    rec {
      # Go packages
      stoml = pkgs.buildGoModule {
        name = "stoml";
        src = stoml-src;
        vendorSha256 = "sha256-37PcS7qVQ+IVZddcm+KbUjRjql7KIzynVGKpIHAk5GY=";
      };
      sconfig = pkgs.buildGoModule {
        name = "sconfig";
        src = sconfig-src;
        vendorSha256 = "sha256-ytpye6zEZC4oLrif8xe6Vr99lblule9HiAyZsSisIPg=";
      };
      cosmovisor = pkgs.buildGoModule {
        name = "cosmovisor";
        src = "${cosmos-sdk-src}/cosmovisor";
        vendorSha256 = "sha256-OAXWrwpartjgSP7oeNvDJ7cTR9lyYVNhEM8HUnv3acE=";
        doCheck = false;
      };
      simd = pkgs.buildGoModule {
        name = "simd";
        src = cleanSourceWithRegexes cosmos-sdk-src [".*cosmovisor.*"];
        vendorSha256 = "sha256-kYoGoNT9W7x8iVjXyMCe72TCeq1RNILw53SmNpv/VXg=";
        doCheck = false;
      };
      # osmosis = mkCosmosGoApp {
      #   name = "osmosis";
      #   version = "v7.0.4";
      #   src = osmosis-src;
      #   vendorSha256 = "sha256-29pmra7bN76Th7VHw4/qyYoGjzVz3nYneB5hEakVVto=";
      #   tags = ["netgo"];
      # };
      regen = mkCosmosGoApp {
        name = "regen-ledger";
        version = "v3.0.0";
        src = {inherit (regen-src) rev;} // cleanSourceWithRegexes regen-src [".*\/orm(\/.*|$|\W)" ".*\/types(\/.*|$|\W)" ".*\/x(\/.*|$|\W)"];
        vendorSha256 = "sha256-IdxIvL8chuGD71q4V7c+RWZ7PoEAVQ7++Crdlz2q/XI=";
        tags = ["netgo"];
      };
      evmos = mkCosmosGoApp {
        name = "evmos";
        version = "v3.0.0-beta";
        src = evmos-src;
        vendorSha256 = "sha256-4zA5JSnhvZAJZ+4tM/kStq6lTTu/fq7GB8tpKgbA/bs";
        tags = ["netgo"];
      };
      relayer = pkgs.buildGoModule {
        name = "relayer";
        src = relayer-src;
        vendorSha256 = "sha256-AelUjtgI9Oua++5TL/MEAAOgxZVxhOW2vEEhNdH3aBk=";
        doCheck = false;
      };

      ica = pkgs.buildGoModule {
        name = "ica";
        src = ica-src;
        vendorSha256 = "sha256-ykGo5TQ+MiFoeQoglflQL3x3VN2CQuyZCIiweP/c9lM=";
      };

      # Rust resources
      hermes = pkgs.rustPlatform.buildRustPackage {
        pname = "ibc-rs";
        version = "v0.13.0-rc.0";
        src = inputs.ibc-rs-src;
        nativeBuildInputs = with pkgs; [rust-bin.stable.latest.default];
        cargoSha256 = "sha256-lIMnZQw46prUFHlAzCWPkKzSNi4F9D+1+aG1vt/5Bvo=";
        doCheck = false;
      };

      # Misc
      gm = with pkgs;
        (import ./resources/gm) {
          inherit shellcheck lib makeWrapper gnused;
          inherit (inputs) ibc-rs-src;
          stoml = packages.stoml;
          sconfig = packages.sconfig;
          mkDerivation = stdenv.mkDerivation;
        };
      ts-relayer =
        ((import ./resources/ts-relayer) {
          inherit pkgs eval-pkgs;
          inherit (inputs) ts-relayer-src;
        })
        .ts-relayer;
      ts-relayer-setup =
        ((import ./resources/ts-relayer) {
          inherit pkgs eval-pkgs;
          inherit (inputs) ts-relayer-src;
        })
        .ts-relayer-setup;
    }
    // gaia-packages
    // ibc-packages;

  # Dev shells
  devShells = {
    nix-shell = pkgs.mkShell {
      shellHook = inputs.self.checks.${system}.pre-commit-check.shellHook;
      buildInputs = with pkgs; [
        rnix-lsp
        pass
        gnupg
        alejandra
        nix-linter
      ];
    };
    cosmos-shell = pkgs.mkShell {
      buildInputs = with pkgs;
        [
          go
          rust-bin.stable.latest.default
          openssl
          shellcheck
        ]
        ++ builtins.attrValues packages;
    };
  };
in {inherit packages devShells;}
