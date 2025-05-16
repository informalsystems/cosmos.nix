{
  celestia-node-src,
  mkCosmosGoApp,
}:
mkCosmosGoApp {
  name = "celestia-node";
  version = "v0.16.0";
  src = celestia-node-src;
  rev = celestia-node-src.rev;
  goVersion = "1.23";
  vendorHash = "sha256-8IDjVQZrOfg4tR//mQxKVoJjaTYJdSuENS5IrAZDdN0=";
  engine = "tendermint/tendermint";
  doCheck = false;
}
