{
  cosmosLib,
  osmosis-src,
  libwasmvm_1_5_0,
}:
cosmosLib.mkCosmosGoApp {
  name = "osmosis";
  version = "v21.0.0";
  src = osmosis-src;
  vendorHash = "sha256-9BBAILwkOhru/35/sc91kf0h3Byz9RJ/P56s2hSmf18=";
  tags = ["netgo"];
  excludedPackages = ["cl-genesis-positions"];
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_0 "osmosisd"}
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_0 "chain"}
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_0 "node"}
  '';
  buildInputs = [libwasmvm_1_5_0];
  proxyVendor = true;

  # Test has to be skipped as end-to-end testing requires network access
  doCheck = false;
}
