{
  wasmd_next-src,
  cosmosLib,
  libwasmvm_1_2_3,
}:
cosmosLib.mkCosmosGoApp {
  name = "wasm";
  version = "v0.40.0-rc.1";
  src = wasmd_next-src;
  vendorHash = "sha256-FWpclJuuIkbcoXxRTeZwDR0wZP2eHkPKsu7xme5vLPg=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  preFixup = cosmosLib.wasmdPreFixupPhase libwasmvm_1_2_3 "wasmd";
  dontStrip = true;
  buildInputs = [libwasmvm_1_2_3];
}
