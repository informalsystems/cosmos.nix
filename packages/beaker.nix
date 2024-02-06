{
  pkgs,
  beaker-src,
}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "beaker";
  version = "0.1.6";
  nativeBuildInputs = with pkgs; [pkg-config];
  OPENSSL_INCLUDE_DIR =
    (
      pkgs.lib.makeSearchPathOutput "dev" "include" [pkgs.openssl.dev]
    )
    + "/openssl";
  OPENSSL_STATIC = "0";
  OPENSSL_NO_VENDOR = 3;
  buildInputs = with pkgs;
    [openssl openssl.dev pkg-config libiconv]
    ++ lib.optionals stdenv.isDarwin
    [darwin.apple_sdk.frameworks.Security];
  src = beaker-src;
  cargoBuildCommand = "cargo build --release --package ${pname}";
  cargoSha256 = "sha256-1FfhDjYDYVYXxVRwzXbGAqsey+29Gxr9CFZ0R9D7+DQ=";
  doCheck = false;
  cargoCheckCommand = "true";
}
