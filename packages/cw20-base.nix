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
    platforms = ["aarch64-linux" "x86_64-linux" "aarch64-darwin"];
  };
}
