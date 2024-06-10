{
  cosmosLib,
  juno-src,
  libwasmvm_1_5_2,
}:
cosmosLib.mkCosmosGoApp {
  name = "juno";
  version = "v22.0.0";
  goVersion = "1.22";
  src = juno-src;
  rev = juno-src.rev;
  vendorHash = "sha256-5TTW7ftC5bQgdKOQJtmAQ8GyAuAtTmeFIl+hh12WX4M=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  excludedPackages = ["interchaintest"];
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "junod"}
  '';
  dontStrip = true;
  buildInputs = [libwasmvm_1_5_2];
}
