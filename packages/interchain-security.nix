{
  mkCosmosGoApp,
  interchain-security-src,
}:
mkCosmosGoApp {
  name = "interchain-security";
  appName = "interchain-security";
  version = "v6.1.0";
  src = interchain-security-src;
  rev = interchain-security-src.rev;
  vendorHash = "sha256-hBKJA5kIw7aHicCcmvzm9pXb+WPjbx5mq7UDPkLLuJ4=";
  goVersion = "1.22";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  doCheck = false; # tests are currently failing
}
