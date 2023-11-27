{
  pkgs,
  cosmwasm-src,
}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "cosmwasm-check";
  version = "1.2.6";
  src = cosmwasm-src;
  cargoBuildCommand = "cargo build --release --package ${pname}";
  cargoSha256 = "sha256-0+CiQv8Up+9Zz9j3qI4R4dpamnsKJL3BJ9C9ZxFXMtI=";
  doCheck = false;
  cargoCheckCommand = "true";
}
