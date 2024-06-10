{
  celestia-app-src,
  mkCosmosGoApp,
}:
mkCosmosGoApp {
  name = "celestia-app";
  version = "v1.11.0";
  src = celestia-app-src;
  rev = celestia-app-src.rev;
  goVersion = "1.22";
  vendorHash = "sha256-O06yhP0XPD8kMhOYS0YVfs1LWwGsbuzuwbetnZ+GAJ8=";
  engine = "tendermint/tendermint";
  doCheck = false;
}
