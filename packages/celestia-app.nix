{
  celestia-app-src,
  mkCosmosGoApp,
}:
mkCosmosGoApp {
  name = "celestia-app";
  version = "v1.14.0";
  src = celestia-app-src;
  rev = celestia-app-src.rev;
  goVersion = "1.22";
  vendorHash = "sha256-xvjdU0GPbqet8L8rvRMZ8AKN7huRn6eDoEYGJYhdJaY=";
  engine = "tendermint/tendermint";
  doCheck = false;
}
