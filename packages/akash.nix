{
  mkCosmosGoApp,
  akash-src,
}:
mkCosmosGoApp {
  name = "akash";
  version = "v0.15.0-rc17";
  appName = "akash";
  src = akash-src;
  vendorSha256 = "sha256-p7GVC1DkOdekfXMaHkXeIZw/CjtTpQCSO0ivDZkmx4c=";
  tags = ["netgo"];
  engine = "tendermint/tendermint";
  doCheck = false;
}
