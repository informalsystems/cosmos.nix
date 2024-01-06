{
  pkgs,
  cosmwasm-src,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "cosmwasm-check";
  version = "1.5.0";
  src = cosmwasm-src;
  cargoLock = {
    lockFile = "${cosmwasm-src}/Cargo.lock";
  };
  doCheck = false;
}
