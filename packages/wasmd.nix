{
  wasmd-src,
  cosmosLib,
  libwasmvm_1_1_1,
}:
cosmosLib.mkCosmosGoApp {
  name = "wasm";
  version = "v0.30.0";
  src = wasmd-src;
  rev = wasmd-src.rev;
  vendorHash = "sha256-8Uo/3SdXwblt87WU78gjpRPcHy+ZotmhF6xTyb3Jxe0";
  tags = ["netgo"];
  engine = "tendermint/tendermint";
  preFixup = cosmosLib.wasmdPreFixupPhase libwasmvm_1_1_1 "wasmd";
  dontStrip = true;
  buildInputs = [libwasmvm_1_1_1];
}
