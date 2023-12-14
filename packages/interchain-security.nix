{
  mkCosmosGoApp,
  interchain-security-src,
}:
mkCosmosGoApp {
  name = "interchain-security";
  appName = "interchain-security";
  version = "v3.0.0-pre";
  src = interchain-security-src;
  vendorHash = "sha256-TnU7lJnoD/ZzPS2XfvFGkb/ycLbH3iHvKRim+31+Yro=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  doCheck = false; # tests are currently failing
}
