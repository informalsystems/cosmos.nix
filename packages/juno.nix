{
  cosmosLib,
  juno-src,
  libwasmvm_1_5_4,
}:
cosmosLib.mkCosmosGoApp {
  name = "juno";
  version = "v24.0.0";
  goVersion = "1.22";
  src = juno-src;
  rev = juno-src.rev;
  vendorHash = "sha256-srBwnVyOx6Zt6n2e6WhZd+uHWNnpyv6fQTi1A9jsVd0=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  excludedPackages = ["interchaintest"];
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_4 "junod"}
  '';
  dontStrip = true;
  buildInputs = [libwasmvm_1_5_4];
}
