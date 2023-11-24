{
  pkgs,
  hermes-src,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "hermes";
  version = "v1.6.0";
  src = hermes-src;
  nativeBuildInputs = with pkgs; [rust-bin.stable.latest.default] ++ utilities.darwin-deps;
  cargoSha256 = "sha256-xCSH8L8do6mS3NKPBZoXKrbJizEDiCJrZnUeG0aisRE=";
  doCheck = false;
  cargoCheckCommand = "true";
}
