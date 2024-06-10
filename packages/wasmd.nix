{
  wasmd-src,
  cosmosLib,
  libwasmvm_2_0_0,
}:
cosmosLib.mkCosmosGoApp {
  name = "wasm";
  version = "v0.51.0";
  goVersion = "1.21";
  src = wasmd-src;
  rev = wasmd-src.rev;
  vendorHash = "sha256-hurRN9NUz5Lh1AOpsZNZEKPYAu+6U6GEsYz4ZUh1aAs=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  preFixup = cosmosLib.wasmdPreFixupPhase libwasmvm_2_0_0 "wasmd";
  dontStrip = true;
  buildInputs = [libwasmvm_2_0_0];

  # main module (github.com/CosmWasm/wasmd) does not contain package github.com/CosmWasm/wasmd/tests/system
  excludedPackages = ["tests/system"];

  doCheck = false;
}
