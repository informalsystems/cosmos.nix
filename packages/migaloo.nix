{
  migaloo-src,
  cosmosLib,
  libwasmvm_1_5_2,
}:
cosmosLib.mkCosmosGoApp {
  name = "migaloo";
  version = "v4.1.3";
  src = migaloo-src;
  rev = migaloo-src.rev;
  vendorHash = "sha256-2rQm+pVniubKXkH3rXlQUOtgXm2Vp0faaqvU7QpEXN4=";
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "migalood"}
  '';
  buildInputs = [libwasmvm_1_5_2];
}
