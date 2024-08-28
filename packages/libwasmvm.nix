{
  pkgs,
  system,
  inputs,
}: let
  libwasmvmCommon = {
    pname = "libwasmvm";
    nativeBuildInputs = with pkgs; [
      rust-bin.stable.latest.default
    ];
    postInstall = ''
      cp ./bindings.h $out/lib/
      ln -s $out/lib/libwasmvm.so $out/lib/libwasmvm.${builtins.head (pkgs.lib.strings.splitString "-" system)}.so
    '';
    doCheck = false;
  };
in
  builtins.mapAttrs (_: libwasmvm: pkgs.rustPlatform.buildRustPackage (libwasmvmCommon // libwasmvm))
  {
    libwasmvm_2_1_0 = {
      src = "${inputs.wasmvm_2_1_0-src}/libwasmvm";
      version = "v2.1.0";
      cargoSha256 = "sha256-BFou131HI+YKXU9H51Xa/y7A441Z7QkAA92mhquJ5l4=";
      cargoLock = {
        lockFile = "${inputs.wasmvm_2_1_0-src}/libwasmvm/Cargo.lock";
        outputHashes = {
          "cosmwasm-crypto-2.1.0" = "sha256-3rCzYh+lNRn4YiRPsFxJ7s4D4QlX+m3Yekz2h22L8vE=";
        };
      };
    };

    libwasmvm_2_0_0 = {
      src = "${inputs.wasmvm_2_0_0-src}/libwasmvm";
      version = "v2.0.0";
      cargoSha256 = "sha256-BFou131HI+YKXU9H51Xa/y7A441Z7QkAA92mhquJ5l4=";
      cargoLock = {
        lockFile = "${inputs.wasmvm_2_0_0-src}/libwasmvm/Cargo.lock";
        outputHashes = {
          "cosmwasm-crypto-2.0.0" = "sha256-wXBWwc1jZsO0kfrh0jkl4+TeFsM/8ZkptCEJSpgsLG8=";
        };
      };
    };

    libwasmvm_1_5_4 = {
      src = "${inputs.wasmvm_1_5_4-src}/libwasmvm";
      version = "v1.5.4";
      cargoSha256 = "sha256-BFou131HI+YKXU9H51Xa/y7A441Z7QkAA92mhquJ5l4=";
      cargoLock = {
        lockFile = "${inputs.wasmvm_1_5_4-src}/libwasmvm/Cargo.lock";
        outputHashes = {
          "cosmwasm-crypto-1.5.7" = "sha256-wQ0nejbnGih/xn/d47CnSZPEJzR9zWxqF8LcYdbkk0o=";
        };
      };
    };

    libwasmvm_1_5_2 = {
      src = "${inputs.wasmvm_1_5_2-src}/libwasmvm";
      version = "v1.5.2";
      cargoSha256 = "sha256-BFou131HI+YKXU9H51Xa/y7A441Z7QkAA92mhquJ5l4=";
      cargoLock = {
        lockFile = "${inputs.wasmvm_1_5_2-src}/libwasmvm/Cargo.lock";
        outputHashes = {
          "cosmwasm-crypto-1.5.2" = "sha256-OgROAoOflWMfiOCuSt52EHiP2E+CzOqLvVJDWufV6kU=";
        };
      };
    };

    libwasmvm_1_5_0 = {
      src = "${inputs.wasmvm_1_5_0-src}/libwasmvm";
      version = "v1.5.0";
      cargoSha256 = "sha256-BFou838HI+YKXU9H51Xa/y7A441Z7QkAA92mhquJ5l4=";
      cargoLock = {
        lockFile = "${inputs.wasmvm_1_5_0-src}/libwasmvm/Cargo.lock";
        outputHashes = {
          "cosmwasm-crypto-1.5.0" = "sha256-41s5jLFzw9Jo+dirAVOad1dtUqCBY6rIz/6TRc0frMw=";
        };
      };
    };

    libwasmvm_1_3_0 = {
      src = "${inputs.wasmvm_1_3_0-src}/libwasmvm";
      version = "v1.3.0";
      cargoSha256 = "sha256-BFou838HI+YKXU9H53Xa/y7A441Z7QkAA92mhquJ5l4=";
      cargoLock = {
        lockFile = "${inputs.wasmvm_1_3_0-src}/libwasmvm/Cargo.lock";
        outputHashes = {
          "cosmwasm-crypto-1.3.0" = "sha256-VU6bPS9z55W4O0rh82O2Zm4oO50cFA4dklNC4Cqmgw0=";
        };
      };
    };

    libwasmvm_1_2_6 = {
      src = "${inputs.wasmvm_1_2_6-src}/libwasmvm";
      version = "v1.2.6";
      cargoSha256 = "sha256-BFou838HI+YKXU9H53Xa/y7A441Z7Qkhf92mhquJ5l1=";
      cargoLock = {
        lockFile = "${inputs.wasmvm_1_2_6-src}/libwasmvm/Cargo.lock";
        outputHashes = {
          "cosmwasm-crypto-1.2.8" = "sha256-EvusaWyqTYk8opcjciTImJLkwVCxEJwbwbzkwsJhilo=";
        };
      };
    };

    libwasmvm_1_2_4 = {
      src = "${inputs.wasmvm_1_2_4-src}/libwasmvm";
      version = "v1.2.4";
      cargoSha256 = "sha256-BFou838HI+YKXU9H53Xa/y7A441Z7Qkhf92mhquJ5l4=";
      cargoLock = {
        lockFile = "${inputs.wasmvm_1_2_4-src}/libwasmvm/Cargo.lock";
        outputHashes = {
          "cosmwasm-crypto-1.2.6" = "sha256-6uhJijuDPXvEZG8mKBGyswsj/JR75Ui713BVx4XD7WI=";
        };
      };
    };

    libwasmvm_1_2_3 = {
      src = "${inputs.wasmvm_1_2_3-src}/libwasmvm";
      version = "v1.2.3";
      cargoSha256 = "sha256-+BaILTe+3qlI+/nz7Nub2hPKiDZlLdL58ckmiBxJtsk=";
      cargoLock = {
        lockFile = "${inputs.wasmvm_1_2_3-src}/libwasmvm/Cargo.lock";
        outputHashes = {
          "cosmwasm-crypto-1.2.4" = "sha256-8BHwgXRNHNB3V1tL+en3IfRHnyeygx5jYz7Sx6duWQg=";
        };
      };
    };

    libwasmvm_1_1_2 = {
      src = "${inputs.wasmvm_1_1_2-src}/libwasmvm";
      version = "v1.1.2";
      cargoSha256 = "sha256-bCnr4TrI+jzvE91n2hhZMuBUPlrO1jXRbU/GFbRzs44=";
      cargoLock = {
        lockFile = "${inputs.wasmvm_1_1_2-src}/libwasmvm/Cargo.lock";
        outputHashes = {
          "cosmwasm-crypto-1.1.10" = "sha256-i8tXVYVLguKd8oAwt8lc1aDzkxTtCaydrkl2X82Lw/Y=";
        };
      };
    };

    libwasmvm_1_1_1 = {
      src = "${inputs.wasmvm_1_1_1-src}/libwasmvm";
      version = "v1.1.1";
      cargoSha256 = "sha256-97BhqI1FZyDbVrT5hdyEK7VPtpE9lQgWduc/siH6NqE";
      cargoLock = {
        lockFile = "${inputs.wasmvm_1_1_1-src}/libwasmvm/Cargo.lock";
        outputHashes = {
          "cosmwasm-crypto-1.1.2" = "sha256-Phg/StSMZA74gGPyQpzjsy3qRO++AWWVnbcu1Ar0WCE=";
        };
      };
    };

    libwasmvm_1 = {
      src = "${inputs.wasmvm_1-src}/libwasmvm";
      version = "v1.0.0";
      cargoSha256 = "sha256-Q8j9wESn2RBb05LcS7FiKGTPLgIPxWA0GZqHlTjkqpU=";
      cargoLock = {
        lockFile = "${inputs.wasmvm_1-src}/libwasmvm/Cargo.lock";
        outputHashes = {
          "cosmwasm-crypto-1.0.0" = "sha256-GuepzBF0BxbPatKZTiRwqPxJewbie+5gwBtOTLWOnng=";
        };
      };
    };

    libwasmvm_1beta7 = {
      src = "${inputs.wasmvm_1_beta7-src}/libwasmvm";
      version = "v1.0.0-beta7";
      cargoSha256 = "sha256-G9wHl2JPgCDoMcykUAM0GrPUbMvSY5PbUzZ6G98rIO8=";
      cargoLock = {
        lockFile = "${inputs.wasmvm_1_beta7-src}/libwasmvm/Cargo.lock";
        outputHashes = {
          "cosmwasm-crypto-1.0.0-beta6" = "sha256-HnskwQ3fOrLG6ImgDYH+/nBYBqdWJDjPtcsTsUz8n2s=";
        };
      };
    };
  }
