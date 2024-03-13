{
  celestia-app-src,
  mkCosmosGoApp,
}:
mkCosmosGoApp {
  name = "celestia-app";
  version = "v1.4.0";
  src = celestia-app-src;
  rev = celestia-app-src.rev;
  goVersion = "1.21";
  vendorHash = "sha256-KvkVqJZ5kvkKWXTYgG7+Ksz8aLhGZPBG5zkM44fVNT4=";
  engine = "tendermint/tendermint";
  doCheck = false;
}
