{
  composable-cosmos-src,
  cosmosLib,
  libwasmvm_1_2_6,
}:
cosmosLib.mkCosmosGoApp {
  name = "centauri";
  version = "v6.4.8";
  src = composable-cosmos-src;
  rev = composable-cosmos-src.rev;
  vendorHash = "sha256-uoolB6FFcz1OiOhtIcngHBovmq/Cc0nrcRYrzi+F6Kc=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  excludedPackages = ["interchaintest" "simd"];
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_2_6 "centaurid"}
  '';
  buildInputs = [libwasmvm_1_2_6];
  proxyVendor = true;
  doCheck = false;
}
