{
  celestia-app-src,
  mkCosmosGoApp,
}:
mkCosmosGoApp {
  name = "celestia-app";
  version = "v2.3.1";
  src = celestia-app-src;
  rev = celestia-app-src.rev;
  goVersion = "1.23";
  vendorHash = "sha256-zL3G+ml2bIcQlthHY6rovr2ykCGHqV51rQBkS3J9tGo=";
  engine = "tendermint/tendermint";
  doCheck = false;

  excludedPackages = ["test/interchain" "test/testground"];
}
