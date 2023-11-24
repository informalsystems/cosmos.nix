{
  celestia-src,
  mkCosmosGoApp,
}:
mkCosmosGoApp {
  name = "celestia";
  version = "v1.1.0";
  src = celestia-src;
  goVersion = "1.21";
  vendorSha256 = "sha256-XA43E8EWTSdBKB1J2tf/11MfByDXHSdNBXcM6q06kj8=";
  engine = "tendermint/tendermint";
  doCheck = false;
}
