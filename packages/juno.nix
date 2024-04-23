{
  cosmosLib,
  juno-src,
  libwasmvm_1_5_2,
}:
cosmosLib.mkCosmosGoApp {
  name = "juno";
  version = "v21.0.0";
  goVersion = "1.21";
  src = juno-src;
  rev = juno-src.rev;
  vendorHash = "sha256-Z5I16c/qRTmJJzAjQp6vmUrSd2F+RV13UYHHnLnhFcE=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  excludedPackages = ["interchaintest"];
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "junod"}
  '';
  dontStrip = true;
  buildInputs = [libwasmvm_1_5_2];
}
