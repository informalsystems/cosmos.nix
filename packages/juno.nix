{
  cosmosLib,
  juno-src,
  libwasmvm_1_3_0,
}:
cosmosLib.mkCosmosGoApp {
  name = "juno";
  version = "v17.1.1";
  src = juno-src;
  vendorHash = "sha256-ftmNMjCFWq4XGM9+ad64dzzcgQJ1ApH4YmthldfrB54=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  excludedPackages = ["interchaintest"];
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_3_0 "junod"}
  '';
  dontStrip = true;
  buildInputs = [libwasmvm_1_3_0];
}
