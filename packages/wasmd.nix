{
  wasmd-src,
  cosmosLib,
  libwasmvm_2_0_0,
}:
cosmosLib.mkCosmosGoApp {
  name = "wasm";
  version = "v0.30.0";
  src = wasmd-src;
  rev = wasmd-src.rev;
  vendorHash = "sha256-8Uo/3SdXwblt87WU78gjpRPcHy+ZotmhF6xTyb3Jxe0";
  tags = ["netgo"];
  engine = "tendermint/tendermint";
  preFixup = cosmosLib.wasmdPreFixupPhase libwasmvm_2_0_0 "wasmd";
  dontStrip = true;
  buildInputs = [libwasmvm_2_0_0];
}
