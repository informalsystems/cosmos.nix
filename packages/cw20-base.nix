{ buildCosmwasmContract
, cw-plus-src,
rustPlatform,
}:
buildCosmwasmContract {
  src = cw-plus-src;
  pname = "cw20-base";
  name = "cw20-base";
  checkPhase = "true";

  cargoLock = {
    lockFile = "${cw-plus-src}/Cargo.lock";
  };
}
  