{
  pkgs,
  namada-src,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "namada";
  version = "v0.28.1";
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
    lib.optionals stdenv.isLinux [
      systemd # required for libudev in custom build script for hidapi
      openssl
      openssl.dev
    ];
  cargoLock = {
    lockFile = "${namada-src}/Cargo.lock";
    outputHashes = {
      "borsh-ext-1.2.0" = "sha256-nQadqyeAY0/gEMLBkpqtSm5D7kV+r3LVT/Cg2oTV7Ug=";
      "clru-0.5.0" = "sha256-/1NfKqcWGCyF3+f0v2CnuFmNjjKkzfvYcX+GzxLwz7s=";
      "ethbridge-bridge-contract-0.24.0" = "sha256-qs81bIWKk4oxh6nFWqAt4eBbPuIWF2a3ytUSjDJZWSU=";
      "index-set-0.8.0" = "sha256-oxJfQdKnYiW5VbMPuukVyDY5n8mys31hYNrJF89nXhY=";
      "ledger-namada-rs-0.0.1" = "sha256-qFL8LU7i5NAnMUhtrGykVfiYX1NodCNkZG07twyVrac=";
      "masp_note_encryption-1.0.0" = "sha256-NwiosHTdzzny+L5VtOBaIa7wia/yRlfiz/8f0pAHUZk=";
      "sparse-merkle-tree-0.3.1-pre" = "sha256-B1ZEN4FZjV0x0Cqvx7AZjH9qhDMZYFPVJzg89dqWCv4=";
      "tiny-bip39-0.8.2" = "sha256-TU+7Vug3+M6Zxhy6Wln54Pxc9ES4EdFq5TvMOcAG+qA=";
      "tower-abci-0.11.1" = "sha256-KisZtsylvUymvV1TpDdGIiE7fSarcuD3I8oZ33BdKTU=";
      "wasmer-2.3.0" = "sha256-Fd8ewAwslopjqUVoeHwSR/Zoh4Zm+Sdx8oksXmhLU20=";
      "zcash_encoding-0.2.0" = "sha256-keuaoM/t1Q/+8JMemMMUuIo4g5I/EAoONFge+dyWGy0=";
    };
  };
  doCheck = false;
}
