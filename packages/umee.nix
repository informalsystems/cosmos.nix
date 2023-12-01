{
  mkCosmosGoApp,
  umee-src,
}:
mkCosmosGoApp {
  name = "umee";
  version = "v2.0.0";
  subPackages = ["cmd/umeed"];
  src = umee-src;
  vendorHash = "sha256-VXBB2ZBh4QFbGQm3bXsl63MeASZMI1++wnhm2IrDrwk=";
  tags = ["netgo"];
  engine = "tendermint/tendermint";
}
