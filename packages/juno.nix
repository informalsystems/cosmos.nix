{
  cosmosLib,
  juno-src,
  libwasmvm_1_5_5,
}:
cosmosLib.mkCosmosGoApp {
  name = "juno";
  version = "v25.0.0";
  goVersion = "1.22";
  src = juno-src;
  rev = juno-src.rev;
  vendorHash = "sha256-HDHsBuuJ+ta3ynYv8NVqEdd0h4UNWBelUA8j+YoEf4E=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  excludedPackages = ["interchaintest"];
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_5 "junod"}
  '';
  dontStrip = true;
  buildInputs = [libwasmvm_1_5_5];
}
