{
  centauri-src,
  cosmosLib,
  libwasmvm_1_5_0,
}:
cosmosLib.mkCosmosGoApp {
  name = "centauri";
  version = "v7.0.0";
  src = centauri-src;
  vendorHash = "sha256-4bkdsF1ez4J1LV2AntyV3uyGJoeawB2Ew2kUFy3qtWg=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  excludedPackages = ["interchaintest" "simd"];
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_0 "centaurid"}
  '';
  buildInputs = [libwasmvm_1_5_0];
  proxyVendor = true;
  doCheck = false;
}
