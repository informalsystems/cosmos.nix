{
  celestia-src,
  mkCosmosGoApp,
}:
mkCosmosGoApp {
  name = "celestia";
  version = "v1.4.0";
  src = celestia-src;
  goVersion = "1.21";
  vendorSha256 = "sha256-KvkVqJZ5kvkKWXTYgG7+Ksz8aLhGZPBG5zkM44fVNT4=";
  engine = "tendermint/tendermint";
  doCheck = false;
}
