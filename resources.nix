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

  utilities = (import ./resources/utilities.nix {inherit pkgs;});

  # Cosmos packages
  packages =
    rec {
      # Go packages
      stoml = pkgs.buildGoModule {
        name = "stoml";
        src = inputs.stoml-src;
        vendorSha256 = "sha256-37PcS7qVQ+IVZddcm+KbUjRjql7KIzynVGKpIHAk5GY=";
      };
      sconfig = pkgs.buildGoModule {
        name = "sconfig";
        src = inputs.sconfig-src;
        vendorSha256 = "sha256-ytpye6zEZC4oLrif8xe6Vr99lblule9HiAyZsSisIPg=";
      };
      cosmovisor = pkgs.buildGoModule {
        name = "cosmovisor";
        src = "${inputs.cosmos-sdk-src}/cosmovisor";
        vendorSha256 = "sha256-OAXWrwpartjgSP7oeNvDJ7cTR9lyYVNhEM8HUnv3acE=";
        doCheck = false;
      };
      simd = pkgs.buildGoModule {
        name = "simd";
        src = cleanSourceWithRegexes inputs.cosmos-sdk-src [".*cosmovisor.*"];
        vendorSha256 = "sha256-kYoGoNT9W7x8iVjXyMCe72TCeq1RNILw53SmNpv/VXg=";
        doCheck = false;
      };

      regen = utilities.mkCosmosGoApp {
        name = "regen-ledger";
        version = "v3.0.0";
        src = {inherit (inputs.regen-src) rev;} // cleanSourceWithRegexes inputs.regen-src [".*\/orm(\/.*|$|\W)" ".*\/types(\/.*|$|\W)" ".*\/x(\/.*|$|\W)"];
        vendorSha256 = "sha256-IdxIvL8chuGD71q4V7c+RWZ7PoEAVQ7++Crdlz2q/XI=";
        tags = ["netgo"];
      };

      evmos = utilities.mkCosmosGoApp {
        name = "evmos";
        version = "v3.0.0-beta";
        src = inputs.evmos-src;
        vendorSha256 = "sha256-4zA5JSnhvZAJZ+4tM/kStq6lTTu/fq7GB8tpKgbA/bs";
        tags = ["netgo"];
      };

      osmosis = utilities.mkCosmosGoApp {
        name = "osmosis";
        version = "v7.0.4";
        src = inputs.osmosis-src;
        vendorSha256 = "sha256-29pmra7bN76Th7VHw4/qyYoGjzVz3nYneB5hEakVVto=";
        tags = ["netgo"];
        preFixup = utilities.wasmdPreFixupPhase "osmosisd";
        dontStrip = true;
        buildInputs = [libwasmvm_1beta7];
      };

      juno = utilities.mkCosmosGoApp {
        name = "juno";
        version = "v2.3.0-beta.2";
        src = inputs.juno-src;
        vendorSha256 = "sha256-2/uu546UYHDBiTMr8QL95aEF7hI8bTkO/JCYMcLM5kw=";
        tags = ["netgo"];
        preFixup = utilities.wasmdPreFixupPhase "junod";
        dontStrip = true;
        buildInputs = [libwasmvm_1beta7];
      };

      terra = utilities.mkCosmosGoApp {
        name = "terra";
        version = "v0.5.17";
        src = inputs.terra-src;
        vendorSha256 = "sha256-2KmSRuSMzg9qFVncrxk+S5hqx8MMpRdo12/HZEaK5Aw=";
        tags = ["netgo"];
        preFixup = utilities.wasmdPreFixupPhase "terrad";
        dontStrip = true;
        buildInputs = [libwasmvm_0_16_3];
      };

      relayer = pkgs.buildGoModule {
        name = "relayer";
        src = inputs.relayer-src;
        vendorSha256 = "sha256-AelUjtgI9Oua++5TL/MEAAOgxZVxhOW2vEEhNdH3aBk=";
        doCheck = false;
      };

      ica = pkgs.buildGoModule {
        name = "ica";
        src = inputs.ica-src;
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

      libwasmvm_1beta7 = pkgs.rustPlatform.buildRustPackage {
        pname = "libwasmvm";
        src = "${inputs.wasmvm_1_beta7-src}/libwasmvm";
        version = "v1.0.0-beta7";
        nativeBuildInputs = with pkgs; [rust-bin.stable.latest.default];
        postInstall = ''
          cp ./bindings.h $out/lib/
        '';
        cargoSha256 = "sha256-G9wHl2JPgCDoMcykUAM0GrPUbMvSY5PbUzZ6G98rIO8=";
        doCheck = false;
      };

      libwasmvm_0_16_3 = pkgs.rustPlatform.buildRustPackage {
        pname = "libwasmvm";
        src = "${inputs.wasmvm_0_16_3-src}/libwasmvm";
        version = "v0.16.3";
        nativeBuildInputs = with pkgs; [rust-bin.stable.latest.default];
        postInstall = ''
          cp ./bindings.h $out/lib/
        '';
        cargoSha256 = "sha256-MUTXxBCIYwCBCDNkFh+JrGMhKg20vC3wCGxqpZVa9Os=";
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
  devShells = rec {
    default = nix-shell;
    nix-shell = pkgs.mkShell {
      shellHook = inputs.self.checks.${system}.pre-commit-check.shellHook;
      buildInputs = with pkgs; [
        rnix-lsp
        pass
        gnupg
        alejandra
        nix-linter
        patchelf
        go_1_18
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
