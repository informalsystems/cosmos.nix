{
  cosmosLib,
  osmosis-src,
  libwasmvm_1_5_2,
}:
cosmosLib.mkCosmosGoApp {
  name = "osmosis";
  version = "v24.0.1";
  goVersion = "1.21";
  src = osmosis-src;
  rev = osmosis-src.rev;
  vendorHash = "sha256-RjBnaHKge3b1CwIFUFsyE/Yv83QC8UsGtx87mgI1PPo=";
  tags = ["netgo"];
  excludedPackages = ["cl-genesis-positions"];
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "osmosisd"}
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "chain"}
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "node"}
  '';
  buildInputs = [libwasmvm_1_5_2];
  proxyVendor = true;

  # Test has to be skipped as end-to-end testing requires network access
  doCheck = false;

  meta = {
    mainProgram = "osmosisd";
  };
}
