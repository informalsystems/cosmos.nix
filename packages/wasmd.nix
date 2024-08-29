{
  wasmd-src,
  cosmosLib,
  libwasmvm_2_1_2,
}:
cosmosLib.mkCosmosGoApp {
  name = "wasm";
  version = "v0.53.0";
  goVersion = "1.21";
  src = wasmd-src;
  rev = wasmd-src.rev;
  vendorHash = "sha256-rhuYWhaTtrHCeO9l4uiP7L2OmWkCPtMHXBqS7TRzM4s=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  preFixup = cosmosLib.wasmdPreFixupPhase libwasmvm_2_1_2 "wasmd";
  dontStrip = true;
  buildInputs = [libwasmvm_2_1_2];

  # main module (github.com/CosmWasm/wasmd) does not contain package github.com/CosmWasm/wasmd/tests/system
  excludedPackages = ["tests/system"];

  doCheck = false;
}
