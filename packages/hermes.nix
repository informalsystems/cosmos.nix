{
  pkgs,
  hermes-src,
}: let
  # penumbra-sdk-proof-params tries to download LFS objects
  # so we need to replace the dependency with one that includes
  # LFS objects pulled by nix
  penumbra-sdk-proof-params-src = pkgs.fetchFromGitHub {
    owner = "penumbra-zone";
    repo = "penumbra";
    hash = "sha256-HLSQvupIqgJE5lPYsAYKobAlPN0uYP3X2UHEM0kD0pE=";
    rev = "v1.0.1";
    sparseCheckout = [
      "crates/crypto/proof-params"
    ];
    fetchLFS = true;
    forceFetchGit = true; # Needed for LFS and sparseCheckout
  };

  cargoConfig = {
    patch.crates-io.penumbra-sdk-proof-params.path = "${penumbra-sdk-proof-params-src}/crates/crypto/proof-params";
  };
  tomlFormat = pkgs.formats.toml {};
  cargoConfigFile = tomlFormat.generate "config.toml" cargoConfig;
in
  pkgs.rustPlatform.buildRustPackage rec {
    pname = "hermes";
    version = "v1.12.0";
    src = hermes-src;
    PROTOC = pkgs.lib.getExe pkgs.protobuf;
    nativeBuildInputs = with pkgs; [
      pkg-config
      rustPlatform.bindgenHook
    ];
    buildInputs = with pkgs;
      [
        openssl
      ]
      ++ lib.lists.optionals stdenv.isDarwin
      [
        darwin.apple_sdk.frameworks.Security
        darwin.apple_sdk.frameworks.SystemConfiguration
      ];
    postUnpack = ''
      cat ${cargoConfigFile} >> source/Cargo.toml
    '';
    cargoSha256 = "sha256-ptlefJSF9oix1t6sU9wFbVAqvXeJckv9LCoG7ozIKCU=";
    # default hash: "sha256-xZrfg82TL6pYBFHhDSV1cdw8O0AvplgHq2Q6kJEq0eA="
    doCheck = false;
    meta = {
      mainProgram = "hermes";
    };
  }
