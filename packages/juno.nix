{
  cosmosLib,
  juno-src,
  libwasmvm_1_5_2,
}:
cosmosLib.mkCosmosGoApp {
  name = "juno";
  version = "v23.0.0";
  goVersion = "1.22";
  src = juno-src;
  rev = juno-src.rev;
  vendorHash = "sha256-oyxW/xvZne3Ybf+1tUUk2qP2gkjGuzdHjWYunXQB8g8=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  excludedPackages = ["interchaintest"];
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "junod"}
  '';
  dontStrip = true;
  buildInputs = [libwasmvm_1_5_2];
}
