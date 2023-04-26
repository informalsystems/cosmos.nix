{
  system,
  inputs,
  pkgs,
  eval-pkgs,
}: let
  gaia-packages = import ./resources/gaia {
    inherit pkgs inputs;
  };

  ibc-packages = import ./resources/ibc-go {
    inherit pkgs inputs;
  };

  utilities = import ./resources/utilities.nix {
    inherit pkgs;
    inherit (inputs) nix-std;
  };

  scripts = import ./scripts {inherit pkgs;};

  cosmos-sdk-version = "v0.46.0";

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
        vendorSha256 = "sha256-APJ+mt8e2zHiO/8UI7Zt63P5HFxEG2ogLf5uxfp58cQ=";
        doCheck = false;
      };

      simd = pkgs.buildGoModule rec {
        name = "simd";
        src = inputs.cosmos-sdk-src;
        vendorSha256 = "sha256-ZlfvpnaF/SBHeXW2tzO3DVEyh1Uh4qNNXBd+AoWd/go=";
        doCheck = false;
        excludedPackages = [
          "./client/v2"
          "./cosmovisor"
          "./container"
          "./core"
          "./db"
          "./errors"
          "./math"
          "./orm"
          "./store/tools"
        ];
        ldflags = ''
          -X github.com/cosmos/cosmos-sdk/version.AppName=${name}
          -X github.com/cosmos/cosmos-sdk/version.Version=${cosmos-sdk-version}
          -X github.com/cosmos/cosmos-sdk/version.Commit=${src.rev}
        '';
      };

      ignite-cli = pkgs.buildGoModule rec {
        name = "ignite-cli";
        src = inputs.ignite-cli-src;
        vendorSha256 = "sha256-P1NYgvdobi6qy1sSKFwkBwPRpLuvCJE5rCD2s/vvm14=";
        doCheck = false;
        ldflags = ''
          -X github.com/ignite/cli/ignite/version.Head=${src.rev}
          -X github.com/ignite/cli/ignite/version.Version=v0.24.0
          -X github.com/ignite/cli/ignite/version.Date=${builtins.toString (src.lastModified)}
        '';
      };

      regen = utilities.mkCosmosGoApp {
        name = "regen-ledger";
        version = "v3.0.0";
        subPackages = ["app/regen"];
        src = inputs.regen-src;
        vendorSha256 = "sha256-IdxIvL8chuGD71q4V7c+RWZ7PoEAVQ7++Crdlz2q/XI=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
      };

      evmos = utilities.mkCosmosGoApp {
        name = "evmos";
        version = "v9.1.0";
        src = inputs.evmos-src;
        vendorSha256 = "sha256-AjWuufyAz5KTBwKiWvhPeqGm4fn3MUqg39xb4pJ0hTM=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
      };

      osmosis = utilities.mkCosmosGoApp {
        name = "osmosis";
        version = "v15.0.0";
        src = inputs.osmosis-src;
        vendorSha256 = "sha256-4RNRAtQmWdi9ZYUH7Rn5VRef/ZhGB7WDwyelUf+U/rc=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        preFixup = ''
          ${utilities.wasmdPreFixupPhase "osmosisd"}
          ${utilities.wasmdPreFixupPhase "chain"}
          ${utilities.wasmdPreFixupPhase "node"}
        '';
        buildInputs = [libwasmvm_1_1_1];
        proxyVendor = true;

        # Test has to be skipped as end-to-end testing requires network access
        doCheck = false;
      };

      osmosis6 = utilities.mkCosmosGoApp {
        name = "osmosis";
        version = "v6.4.1";
        src = inputs.osmosis6-src;
        vendorSha256 = "sha256-UI5QGQsTLPnsDWWPUG+REsvF4GIeFeNHOiG0unNXmdY=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
      };

      osmosis7 = utilities.mkCosmosGoApp {
        name = "osmosis";
        version = "v7.3.0";
        src = inputs.osmosis7-src;
        excludedPackages = "./tests/e2e";
        vendorSha256 = "sha256-sdj59aZJBF4kpolHnYOHHO4zs7vKFu0i1xGKZFEiOyQ=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        preFixup = utilities.wasmdPreFixupPhase "osmosisd";
        buildInputs = [libwasmvm_1];

        # Test has to be skipped as end-to-end testing requires network access
        doCheck = false;
      };

      osmosis8 = utilities.mkCosmosGoApp {
        name = "osmosis";
        version = "v8.0.0";
        src = inputs.osmosis8-src;
        excludedPackages = "./tests/e2e";
        vendorSha256 = "sha256-sdj59aZJBF4kpolHnYOHHO4zs7vKFu0i1xGKZFEiOyQ=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        preFixup = utilities.wasmdPreFixupPhase "osmosisd";
        dontStrip = true;
        buildInputs = [libwasmvm_1beta7];

        # Test has to be skipped as end-to-end testing requires network access
        doCheck = false;
      };

      juno = utilities.mkCosmosGoApp {
        name = "juno";
        version = "v13.0.1";
        src = inputs.juno-src;
        vendorSha256 = "sha256-0EsEzkEY4N4paQ+OPV7MVUTwOr8F2uCCLi6NQ3JSlgM=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        preFixup = ''
          ${utilities.wasmdPreFixupPhase "junod"}
          ${utilities.wasmdPreFixupPhase "chain"}
          ${utilities.wasmdPreFixupPhase "node"}
        '';
        dontStrip = true;
        buildInputs = [libwasmvm_1_1_1];
      };

      terra = utilities.mkCosmosGoApp {
        name = "terra";
        version = "v0.5.17";
        src = inputs.terra-src;
        vendorSha256 = "sha256-2KmSRuSMzg9qFVncrxk+S5hqx8MMpRdo12/HZEaK5Aw=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        preFixup = utilities.wasmdPreFixupPhase "terrad";
        dontStrip = true;
        buildInputs = [libwasmvm_0_16_3];
      };

      sentinel = utilities.mkCosmosGoApp {
        name = "sentinel";
        version = "v9.0.0-rc0";
        appName = "sentinelhub";
        src = inputs.sentinel-src;
        vendorSha256 = "sha256-ktIKTw7J4EYKWu6FBfxzvYm8ldHG00KakRY5QR8cjrI=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
      };

      akash = utilities.mkCosmosGoApp {
        name = "akash";
        version = "v0.15.0-rc17";
        appName = "akash";
        src = inputs.akash-src;
        vendorSha256 = "sha256-p7GVC1DkOdekfXMaHkXeIZw/CjtTpQCSO0ivDZkmx4c=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        doCheck = false;
      };

      umee = utilities.mkCosmosGoApp {
        name = "umee";
        version = "v2.0.0";
        subPackages = ["cmd/umeed"];
        src = inputs.umee-src;
        vendorSha256 = "sha256-HONlFCC6iHgKQwqAiEV29qmSHsLdloUlAeJkxViUG7w=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
      };

      ixo = pkgs.buildGoModule {
        name = "ixo";
        version = "v0.18.0-rc1";
        src = inputs.ixo-src;
        vendorSha256 = "sha256-g6dKujkFZLpFGpxgzb7v1YOo4cdeP6eEAbUjMzAIkF8=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        doCheck = false;
      };

      sifchain = utilities.mkCosmosGoApp {
        name = "sifchain";
        version = "v0.12.1";
        src = inputs.sifchain-src;
        vendorSha256 = "sha256-AX5jLfH9RnoGZm5MVyM69NnxVjYMR45CNaKzQn5hsXg=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        additionalLdFlags = ''
          -X github.com/cosmos/cosmos-sdk/version.ServerName=sifnoded
          -X github.com/cosmos/cosmos-sdk/version.ClientName=sifnoded
        '';
        appName = "sifnoded";
        doCheck = false;
      };

      crescent = utilities.mkCosmosGoApp {
        name = "crescent";
        version = "v1.0.0-rc3";
        src = inputs.crescent-src;
        vendorSha256 = "sha256-WLLQKXjPRhK19oEdqp2UBZpi9W7wtYjJMj07omH41K0=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        additionalLdFlags = ''
          -X github.com/cosmos/cosmos-sdk/types.reDnmString=[a-zA-Z][a-zA-Z0-9/:]{2,127}
        '';
      };

      stargaze = utilities.mkCosmosGoApp {
        name = "stargaze";
        appName = "starsd";
        version = "v3.0.0";
        src = inputs.stargaze-src;
        buildInputs = [libwasmvm_1beta7];
        vendorSha256 = "sha256-IJwyjto86gnWyeux1AS+aPZONhpyB7+MSQcCRs3LHzw=";
        preFixup = utilities.wasmdPreFixupPhase "starsd";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
      };

      interchain-security = utilities.mkCosmosGoApp {
        name = "interchain-security";
        appName = "interchain-security";
        version = "v1.0.4";
        src = inputs.interchain-security-src;
        vendorSha256 = "sha256-BLadou3/JfumdjbXVJnVMZahARXxVDpvSWJzzK6ilxA=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        doCheck = false; # tests are currently failing
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

      wasmd = utilities.mkCosmosGoApp {
        name = "wasm";
        version = "v0.30.0";
        src = inputs.wasmd-src;
        vendorSha256 = "sha256-8Uo/3SdXwblt87WU78gjpRPcHy+ZotmhF6xTyb3Jxe0";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        preFixup = utilities.wasmdPreFixupPhase "wasmd";
        dontStrip = true;
        buildInputs = [libwasmvm_1_1_1];
      };

      stride = utilities.mkCosmosGoApp {
        name = "stride";
        version = "v8.0.0";
        src = inputs.stride-src;
        vendorSha256 = "sha256-z4vT4CeoJF76GwljHm2L2UF1JxyEJtvqAkP9TmIgs10=";
        engine = "tendermint/tendermint";

        doCheck = false;
      };

      stride-no-admin = utilities.mkCosmosGoApp {
        name = "stride-no-admin";
        version = "v8.0.0";
        src = inputs.stride-src;
        vendorSha256 = "sha256-z4vT4CeoJF76GwljHm2L2UF1JxyEJtvqAkP9TmIgs10=";
        engine = "tendermint/tendermint";

        patches = [./patches/stride-no-admin-check.patch];
        doCheck = false;
      };

      # Rust resources
      hermes = pkgs.rustPlatform.buildRustPackage {
        pname = "hermes";
        version = "v1.0.0";
        src = inputs.ibc-rs-src;
        nativeBuildInputs = with pkgs; [rust-bin.stable.latest.default];
        cargoSha256 = "sha256-0GZN3xq/5FC/jYXGVDIOrha+sB+Gv/6nzlFvpCAYO3M=";
        doCheck = false;
      };

      libwasmvm_1_1_1 = pkgs.rustPlatform.buildRustPackage {
        pname = "libwasmvm";
        src = "${inputs.wasmvm_1_1_1-src}/libwasmvm";
        version = "v1.1.1";
        nativeBuildInputs = with pkgs; [rust-bin.stable.latest.default];
        postInstall = ''
          cp ./bindings.h $out/lib/
          ln -s $out/lib/libwasmvm.so $out/lib/libwasmvm.${builtins.head (pkgs.lib.strings.splitString "-" system)}.so
        '';
        cargoSha256 = "sha256-97BhqI1FZyDbVrT5hdyEK7VPtpE9lQgWduc/siH6NqE";
        doCheck = false;
      };

      libwasmvm_1 = pkgs.rustPlatform.buildRustPackage {
        pname = "libwasmvm";
        src = "${inputs.wasmvm_1-src}/libwasmvm";
        version = "v1.0.0";
        nativeBuildInputs = with pkgs; [rust-bin.stable.latest.default];
        postInstall = ''
          cp ./bindings.h $out/lib/
          ln -s $out/lib/libwasmvm.so $out/lib/libwasmvm.${builtins.head (pkgs.lib.strings.splitString "-" system)}.so
        '';
        cargoSha256 = "sha256-Q8j9wESn2RBb05LcS7FiKGTPLgIPxWA0GZqHlTjkqpU=";
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

      apalache = import ./resources/apalache.nix {
        inherit pkgs;
        inherit (inputs) apalache-src;
      };

      tx-database-migration = pkgs.writeTextFile {
        name = "tx_index_schema.sql";
        text = builtins.readFile ./fixtures/tx_index_schema.sql;
      };
    }
    // gaia-packages
    // ibc-packages;

  # Dev shells
  devShells = rec {
    default = nix-shell;
    nix-shell = pkgs.mkShell {
      shellHook = inputs.self.checks.${system}.pre-commit-check.shellHook;
      buildInputs = with pkgs;
        [
          rnix-lsp
          pass
          gnupg
          alejandra
          patchelf
          go
        ]
        ++ scripts;
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

    osmosis-shell = pkgs.mkShell {
      buildInputs = with pkgs; [
        wget
        jq
        curl
        lz4
        python39
        packages.osmosis8
        packages.cosmovisor
      ];
      shellHook = ''
        export DAEMON_NAME=osmosisd
        export DAEMON_HOME=$HOME/.osmosisd
        export DAEMON_ALLOW_DOWNLOAD_BINARIES=false
        export DAEMON_LOG_BUFFER_SIZE=512
        export DAEMON_RESTART_AFTER_UPGRADE=true
        export UNSAFE_SKIP_BACKUP=true
      '';
    };
  };
in {inherit packages devShells;}
