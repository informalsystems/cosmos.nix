{
  wasmd_next-src,
  cosmosLib,
  libwasmvm_1_2_3,
}:
cosmosLib.mkCosmosGoApp {
  name = "wasm";
  version = "v0.40.0-rc.1";
  src = wasmd_next-src;
  rev = wasmd_next-src.rev;
  vendorHash = "sha256-FWpclJuuIkbcoXxRTeZwDR0wZP2eHkPKsu7xme5vLPg=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  preFixup = cosmosLib.wasmdPreFixupPhase libwasmvm_2_0_0 "wasmd";
  dontStrip = true;
  buildInputs = [libwasmvm_2_0_0];
}
