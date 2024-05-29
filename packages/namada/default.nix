{
  pkgs,
  namada-src,
}:
rec {
  namada = pkgs.rustPlatform.buildRustPackage {
    pname = "namada";
    version = "v0.37.0-yuji/for-hermes-ci";
    src = namada-src;
    nativeBuildInputs = with pkgs;
      (
        if stdenv.isLinux
        then [pkg-config]
        else [darwin.apple_sdk.frameworks.Security]
      )
      ++ [
        protobuf
        rustPlatform.bindgenHook # required for bindgen in custom build script for librocksdb-sys
      ];
    buildInputs = with pkgs;
      [
        openssl
        openssl.dev
      ]
      ++ lib.optionals stdenv.isLinux [
        systemd # required for libudev in custom build script for hidapi
      ]
      ++ lib.optionals stdenv.isDarwin [
        libusb
        hidapi
      ];

    cargoLock = {
      lockFile = "${namada-src}/Cargo.lock";
      outputHashes = {
        "borsh-ext-1.2.0" = "sha256-nQadqyeAY0/gEMLBkpqtSm5D7kV+r3LVT/Cg2oTV7Ug=";
        "clru-0.5.0" = "sha256-/1NfKqcWGCyF3+f0v2CnuFmNjjKkzfvYcX+GzxLwz7s=";
        "ethbridge-bridge-contract-0.24.0" = "sha256-qs81bIWKk4oxh6nFWqAt4eBbPuIWF2a3ytUSjDJZWSU=";
        "indexmap-2.2.4" = "sha256-uG8XMuoFt79cCZ8kqundQs++rqDLC/0ppiWToeAk5BE=";
        "index-set-0.8.0" = "sha256-oxJfQdKnYiW5VbMPuukVyDY5n8mys31hYNrJF89nXhY=";
        "ledger-namada-rs-0.0.1" = "sha256-qFL8LU7i5NAnMUhtrGykVfiYX1NodCNkZG07twyVrac=";
        "librocksdb-sys-0.16.0+8.10.0" = "sha256-ZcX2bpTDprcefo1ziyQ58GggX2D7NH17/zYvpbGSvhk=";
        "masp_note_encryption-1.0.0" = "sha256-zyCycYJtXSyaq0lG0QeQPKM4EI4VJ4sJ/k8IXFpNqA4=";
        "num-traits-0.2.19" = "sha256-j6DT5w07A2qBfwojNA3y1eZNP6+BV4A+SRWbtFXLuXo=";
        "smooth-operator-0.6.0" = "sha256-G5Mtk2Ab0VD5IvFgm/KTHNKOjK/yLP9MP4xTKRz979M=";
        "sparse-merkle-tree-0.3.1-pre" = "sha256-ckgX6XQj1TMRdDHC8P/jy5Mt0l1hnXdacE6jjViXJsE=";
        "tiny-bip39-0.8.2" = "sha256-TU+7Vug3+M6Zxhy6Wln54Pxc9ES4EdFq5TvMOcAG+qA=";
        "tiny-hderive-0.3.0" = "sha256-75D7h8S1/bMTlh3hq8YBAcgyzYBwBOvU249VdzQsICI=";
        "wasmer-2.3.0" = "sha256-lBipiaoYaEjJg9iZZrVhF1lUNH90QZ29xAHGBBhdujE=";
        "zcash_encoding-0.2.0" = "sha256-keuaoM/t1Q/+8JMemMMUuIo4g5I/EAoONFge+dyWGy0=";
      };
    };
    preBuild = ''
      export RUSTUP_TOOLCHAIN="1.77.1"
    '';
    doCheck = false;
  };
}
