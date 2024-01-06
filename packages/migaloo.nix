{
  migaloo-src,
  cosmosLib,
  libwasmvm_1_2_3,
}:
cosmosLib.mkCosmosGoApp {
  name = "migaloo";
  version = "v3.0.2";
  src = migaloo-src;
  rev = migaloo-src.rev;
  vendorHash = "sha256-GQDfI4hSkkrsBfIczdGoOhghR7/FqEvXavyP4E6iHM4=";
  engine = "tendermint/tendermint";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_2_3 "migalood"}
  '';
  buildInputs = [libwasmvm_1_2_3];
}
