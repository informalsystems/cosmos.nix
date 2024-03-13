{
  celestia-node-src,
  mkCosmosGoApp,
}:
mkCosmosGoApp {
  name = "celestia-node";
  version = "v0.13.0";
  src = celestia-node-src;
  rev = celestia-node-src.rev;
  goVersion = "1.21";
  vendorHash = "sha256-wUyb6gZ9n+wOBagJ1BdKcbBGtLIaVyaRH6NHSJ7VFk8=";
  engine = "tendermint/tendermint";
  doCheck = false;
}
