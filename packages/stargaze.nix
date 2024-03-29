{
  cosmosLib,
  stargaze-src,
  libwasmvm_1beta7,
}:
cosmosLib.mkCosmosGoApp {
  name = "stargaze";
  appName = "starsd";
  version = "v3.0.0";
  src = stargaze-src;
  rev = stargaze-src.rev;
  buildInputs = [libwasmvm_1beta7];
  vendorHash = "sha256-IJwyjto86gnWyeux1AS+aPZONhpyB7+MSQcCRs3LHzw=";
  preFixup = cosmosLib.wasmdPreFixupPhase libwasmvm_1beta7 "starsd";
  tags = ["netgo"];
  engine = "tendermint/tendermint";
}
