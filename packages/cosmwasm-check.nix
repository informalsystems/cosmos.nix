{
  pkgs,
  cosmwasm-src,
}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "cosmwasm-check";
  version = "1.5.0";
  src = cosmwasm-src;
  cargoBuildCommand = "cargo build --release --package ${pname}";
  cargoLock = {
    lockFile = "${cosmwasm-src}/Cargo.lock";
  };
  doCheck = false;
  cargoCheckCommand = "true";
}
