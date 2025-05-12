{
  buildCosmwasmContract,
  cw-plus-src,
}:
buildCosmwasmContract {
  src = cw-plus-src;
  pname = "cw20-base";
  name = "cw20-base";

  cargoLock = {
    lockFile = "${cw-plus-src}/Cargo.lock";
  };

  meta = {
    # Prevent failure due to missing `rustc.targetPlatforms`
    platforms = ["aarch64-darwin" "x86_64-linux"];
  };
}
