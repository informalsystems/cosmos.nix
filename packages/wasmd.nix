{
  wasmd-src,
  cosmosLib,
  libwasmvm_1_5_0,
}:
cosmosLib.mkCosmosGoApp {
  name = "wasm";
  version = "v0.50.0";
  goVersion = "1.21";
  src = wasmd-src;
  rev = wasmd-src.rev;
  vendorHash = "sha256-IS+WupPaOZgx1iJTHKbX8r6z3/9TsWamTEZCJbVpCOg=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  preFixup = cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_0 "wasmd";
  dontStrip = true;
  buildInputs = [libwasmvm_1_5_0];

  # main module (github.com/CosmWasm/wasmd) does not contain package github.com/CosmWasm/wasmd/tests/system
  excludedPackages = ["tests/system"];

  doCheck = false;
}
