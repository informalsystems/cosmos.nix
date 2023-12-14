{
  centauri-src,
  cosmosLib,
  libwasmvm_1_2_4,
}:
cosmosLib.mkCosmosGoApp {
  name = "centauri";
  version = "v6.3.1";
  src = centauri-src;
  vendorHash = "sha256-MRADQxw+T8lVJujJn2yEaZOEs6AYGgaiBbYJUI3cugA=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  excludedPackages = ["interchaintest" "simd"];
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_2_4 "centaurid"}
  '';
  buildInputs = [libwasmvm_1_2_4];
  proxyVendor = true;
  doCheck = false;
}
