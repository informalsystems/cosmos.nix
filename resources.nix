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

  libwasmvm = {
    pname = "libwasmvm";
    nativeBuildInputs = with pkgs; [rust-bin.stable.latest.default];
    postInstall = ''
      cp ./bindings.h $out/lib/
      ln -s $out/lib/libwasmvm.so $out/lib/libwasmvm.${builtins.head (pkgs.lib.strings.splitString "-" system)}.so
    '';
    doCheck = false;
  };

  packages =
    rec {
      # Go packages
      stoml = pkgs.buildGoModule {
        name = "stoml";
        src = inputs.stoml-src;
        vendorSha256 = "sha256-i5m2I0IApTwD9XIjsDwU4dpNtwGI0EGeSkY6VbXDOAM=";
      };

      sconfig = pkgs.buildGoModule {
        name = "sconfig";
        src = inputs.sconfig-src;
        vendorSha256 = "sha256-J3L8gPtCShn//3mliMzvRTxRgb86f1pJ+yjZkF5ixEk=";
      };

      cometbft = pkgs.buildGoModule {
        name = "cometbft";
        src = inputs.cometbft-src;
        vendorSha256 = "sha256-rZeC0B5U0bdtZAw/hnMJ7XG73jN0nsociAN8GGdmlUY=";
        doCheck = false;
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
        version = "v19.2.0";
        src = inputs.osmosis-src;
        vendorSha256 = "sha256-z1lGckpsrCui8VQow3ciy6yl5LL5NxHMIU+SGL9wvKs=";
        tags = ["netgo"];
        excludedPackages = ["cl-genesis-positions"];
        engine = "tendermint/tendermint";
        preFixup = ''
          ${utilities.wasmdPreFixupPhase libwasmvm_1_2_3 "osmosisd"}
          ${utilities.wasmdPreFixupPhase libwasmvm_1_2_3 "chain"}
          ${utilities.wasmdPreFixupPhase libwasmvm_1_2_3 "node"}
        '';
        buildInputs = [libwasmvm_1_2_3];
        proxyVendor = true;

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
          ${utilities.wasmdPreFixupPhase libwasmvm_1_1_1 "junod"}
          ${utilities.wasmdPreFixupPhase libwasmvm_1_1_1 "chain"}
          ${utilities.wasmdPreFixupPhase libwasmvm_1_1_1 "node"}
        '';
        dontStrip = true;
        buildInputs = [libwasmvm_1_1_1];
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
        vendorSha256 = "sha256-VXBB2ZBh4QFbGQm3bXsl63MeASZMI1++wnhm2IrDrwk=";
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
        preFixup = utilities.wasmdPreFixupPhase libwasmvm_1beta7 "starsd";
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
        vendorSha256 = "sha256-oJSxRUKXhjpDWk0bk7Q8r0AAc7UOhEOLj+SgsZsnzsk=";
        doCheck = false;
      };

      ica = pkgs.buildGoModule {
        name = "ica";
        src = inputs.ica-src;
        vendorSha256 = "sha256-ZIP6dmHugLLtdA/8N8byg3D3JinjNxpvxyK/qiIs7bI=";
      };

      wasmd = utilities.mkCosmosGoApp {
        name = "wasm";
        version = "v0.30.0";
        src = inputs.wasmd-src;
        vendorSha256 = "sha256-8Uo/3SdXwblt87WU78gjpRPcHy+ZotmhF6xTyb3Jxe0";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        preFixup = utilities.wasmdPreFixupPhase libwasmvm_1_1_1 "wasmd";
        dontStrip = true;
        buildInputs = [libwasmvm_1_1_1];
      };

      wasmd_next = utilities.mkCosmosGoApp {
        name = "wasm";
        version = "v0.40.0-rc.1";
        src = inputs.wasmd_next-src;
        vendorSha256 = "sha256-FWpclJuuIkbcoXxRTeZwDR0wZP2eHkPKsu7xme5vLPg=";
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        preFixup = utilities.wasmdPreFixupPhase libwasmvm_1_2_3 "wasmd";
        dontStrip = true;
        buildInputs = [libwasmvm_1_2_3];
      };

      stride = utilities.mkCosmosGoApp {
        name = "stride";
        version = "v8.0.0";
        src = inputs.stride-src;
        vendorSha256 = "sha256-z4vT4CeoJF76GwljHm2L2UF1JxyEJtvqAkP9TmIgs10=";
        engine = "tendermint/tendermint";

        doCheck = false;
      };

      stride-consumer = utilities.mkCosmosGoApp {
        name = "stride-consumer";
        version = "v12.1.0";
        src = inputs.stride-consumer-src;
        vendorSha256 = "sha256-tH56oB9Lw0/+ypWRj9n8o/QHPcLQuuNkzD4zFy6bW04=";
        engine = "cometbft/cometbft";

        doCheck = false;
      };

      stride-consumer-no-admin = utilities.mkCosmosGoApp {
        name = "stride-consumer-no-admin";
        version = "v12.1.0";
        src = inputs.stride-consumer-src;
        vendorSha256 = "sha256-tH56oB9Lw0/+ypWRj9n8o/QHPcLQuuNkzD4zFy6bW04=";
        engine = "cometbft/cometbft";

        patches = [./patches/stride-no-admin-check.patch];
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

      migaloo = utilities.mkCosmosGoApp {
        name = "migaloo";
        version = "v2.0.2";
        src = inputs.migaloo-src;
        vendorSha256 = "sha256-Z85OpuiB73BHSSuPADvE3tJ5ZstHYik8yghfCHXy3W0=";
        engine = "tendermint/tendermint";
        preFixup = ''
          ${utilities.wasmdPreFixupPhase libwasmvm_1_2_3 "migalood"}
        '';
        buildInputs = [libwasmvm_1_2_3];
      };

      celestia = utilities.mkCosmosGoApp {
        name = "celestia";
        version = "v1.1.0";
        src = inputs.celestia-src;
        goVersion = "1.21";
        vendorSha256 = "sha256-XA43E8EWTSdBKB1J2tf/11MfByDXHSdNBXcM6q06kj8=";
        engine = "tendermint/tendermint";

        doCheck = false;
      };

      neutron = utilities.mkCosmosGoApp {
        name = "neutron";
        version = "v1.0.2";
        src = inputs.neutron-src;
        vendorSha256 = "sha256-Q3QEk7qS1ue/HrvwdkGh6iX8BTg+0ssznyWsYtzZ+/4=";
        engine = "tendermint/tendermint";
        preFixup = ''
          ${utilities.wasmdPreFixupPhase libwasmvm_1_2_3 "neutrond"}
        '';
        buildInputs = [libwasmvm_1_2_3];
      };

      centauri = utilities.mkCosmosGoApp {
        name = "centauri";
        version = "v6.0.3";
        src = inputs.centauri-src;
        vendorSha256 = "sha256-mNp5FLIw66xvqcv9tqC0cDGLyhRAwP9dTKeRjBx01kE=";
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        excludedPackages = ["interchaintest" "simd"];
        preFixup = ''
          ${utilities.wasmdPreFixupPhase libwasmvm_1_2_4 "centaurid"}
        '';
        buildInputs = [libwasmvm_1_2_4];
        proxyVendor = true;
        doCheck = false;
      };

      # Hermes IBC relayer
      hermes = pkgs.rustPlatform.buildRustPackage {
        pname = "hermes";
        version = "v1.6.0";
        src = inputs.hermes-src;
        nativeBuildInputs = with pkgs; [rust-bin.stable.latest.default] ++ utilities.darwin-deps;
        cargoSha256 = "sha256-xCSH8L8do6mS3NKPBZoXKrbJizEDiCJrZnUeG0aisRE=";
        doCheck = false;
        cargoCheckCommand = "true";
      };

      # Rust resources
      cosmwasm-check = pkgs.rustPlatform.buildRustPackage rec {
        pname = "cosmwasm-check";
        version = "1.2.6";
        src = inputs.cosmwasm-src;
        cargoBuildCommand = "cargo build --release --package ${pname}";
        cargoSha256 = "sha256-0+CiQv8Up+9Zz9j3qI4R4dpamnsKJL3BJ9C9ZxFXMtI=";
        doCheck = false;
        cargoCheckCommand = "true";
      };

      beaker = with pkgs;
        pkgs.rustPlatform.buildRustPackage rec {
          pname = "beaker";
          version = "0.1.6";
          nativeBuildInputs = lib.optionals stdenv.isLinux [pkg-config] ++ utilities.darwin-deps;
          OPENSSL_NO_VENDOR = 3;
          buildInputs = lib.optionals stdenv.isLinux [openssl openssl.dev];
          src = inputs.beaker-src;
          cargoBuildCommand = "cargo build --release --package ${pname}";
          cargoSha256 = "sha256-1FfhDjYDYVYXxVRwzXbGAqsey+29Gxr9CFZ0R9D7+DQ=";
          doCheck = false;
          cargoCheckCommand = "true";
        };

      libwasmvm_1_2_4 = pkgs.rustPlatform.buildRustPackage (libwasmvm
        // rec {
          src = "${inputs.wasmvm_1_2_4-src}/libwasmvm";
          version = "v1.2.4";
          cargoSha256 = "sha256-BFou838HI+YKXU9H53Xa/y7A441Z7Qkhf92mhquJ5l4=";
          cargoLock = {
            lockFile = "${src}/Cargo.lock";
            outputHashes = {
              "cosmwasm-crypto-1.2.6" = "sha256-6uhJijuDPXvEZG8mKBGyswsj/JR75Ui713BVx4XD7WI=";
            };
          };
        });

      libwasmvm_1_2_3 = pkgs.rustPlatform.buildRustPackage (libwasmvm
        // rec {
          src = "${inputs.wasmvm_1_2_3-src}/libwasmvm";
          version = "v1.2.3";
          cargoSha256 = "sha256-+BaILTe+3qlI+/nz7Nub2hPKiDZlLdL58ckmiBxJtsk=";
          cargoLock = {
            lockFile = "${src}/Cargo.lock";
            outputHashes = {
              "cosmwasm-crypto-1.2.4" = "sha256-8BHwgXRNHNB3V1tL+en3IfRHnyeygx5jYz7Sx6duWQg=";
            };
          };
        });

      libwasmvm_1_1_2 = pkgs.rustPlatform.buildRustPackage (libwasmvm
        // rec {
          src = "${inputs.wasmvm_1_1_2-src}/libwasmvm";
          version = "v1.1.2";
          cargoSha256 = "sha256-bCnr4TrI+jzvE91n2hhZMuBUPlrO1jXRbU/GFbRzs44=";
          cargoLock = {
            lockFile = "${src}/Cargo.lock";
            outputHashes = {
              "cosmwasm-crypto-1.1.10" = "sha256-i8tXVYVLguKd8oAwt8lc1aDzkxTtCaydrkl2X82Lw/Y=";
            };
          };
        });

      libwasmvm_1_1_1 = pkgs.rustPlatform.buildRustPackage (libwasmvm
        // rec {
          src = "${inputs.wasmvm_1_1_1-src}/libwasmvm";
          version = "v1.1.1";
          cargoSha256 = "sha256-97BhqI1FZyDbVrT5hdyEK7VPtpE9lQgWduc/siH6NqE";
          cargoLock = {
            lockFile = "${src}/Cargo.lock";
            outputHashes = {
              "cosmwasm-crypto-1.1.2" = "sha256-Phg/StSMZA74gGPyQpzjsy3qRO++AWWVnbcu1Ar0WCE=";
            };
          };
        });

      libwasmvm_1 = pkgs.rustPlatform.buildRustPackage (libwasmvm
        // rec {
          src = "${inputs.wasmvm_1-src}/libwasmvm";
          version = "v1.0.0";
          cargoSha256 = "sha256-Q8j9wESn2RBb05LcS7FiKGTPLgIPxWA0GZqHlTjkqpU=";
          cargoLock = {
            lockFile = "${src}/Cargo.lock";
            outputHashes = {
              "cosmwasm-crypto-1.0.0" = "sha256-GuepzBF0BxbPatKZTiRwqPxJewbie+5gwBtOTLWOnng=";
            };
          };
        });

      libwasmvm_1beta7 = pkgs.rustPlatform.buildRustPackage (libwasmvm
        // rec {
          src = "${inputs.wasmvm_1_beta7-src}/libwasmvm";
          version = "v1.0.0-beta7";
          cargoSha256 = "sha256-G9wHl2JPgCDoMcykUAM0GrPUbMvSY5PbUzZ6G98rIO8=";
          cargoLock = {
            lockFile = "${src}/Cargo.lock";
            outputHashes = {
              "cosmwasm-crypto-1.0.0-beta6" = "sha256-HnskwQ3fOrLG6ImgDYH+/nBYBqdWJDjPtcsTsUz8n2s=";
            };
          };
        });

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

      gex = pkgs.buildGoModule {
        name = "gex";
        doCheck = false;
        src = inputs.gex-src;
        vendorSha256 = "sha256-3vD0ge0zWSnGoeh5FAFEw60a7q5/YWgDsGjjgibBBNI=";
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
        packages.osmosis
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
