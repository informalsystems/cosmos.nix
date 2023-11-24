{
  migaloo-src,
  cosmosLib,
  libwasmvm_1_2_3,
}:
cosmosLib.mkCosmosGoApp {
  name = "migaloo";
  version = "v2.0.2";
  src = migaloo-src;
  vendorSha256 = "sha256-Z85OpuiB73BHSSuPADvE3tJ5ZstHYik8yghfCHXy3W0=";
  engine = "tendermint/tendermint";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_2_3 "migalood"}
  '';
  buildInputs = [libwasmvm_1_2_3];
}
