{
  pkgs,
  beaker-src,
}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "beaker";
  version = "0.1.6";
  nativeBuildInputs = with pkgs; lib.optionals stdenv.isLinux [pkg-config] ++ utilities.darwin-deps;
  OPENSSL_NO_VENDOR = 3;
  buildInputs = with pkgs; lib.optionals stdenv.isLinux [openssl openssl.dev];
  src = beaker-src;
  cargoBuildCommand = "cargo build --release --package ${pname}";
  cargoSha256 = "sha256-1FfhDjYDYVYXxVRwzXbGAqsey+29Gxr9CFZ0R9D7+DQ=";
  doCheck = false;
  cargoCheckCommand = "true";
}
