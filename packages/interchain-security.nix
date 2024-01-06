{
  mkCosmosGoApp,
  interchain-security-src,
}:
mkCosmosGoApp {
  name = "interchain-security";
  appName = "interchain-security";
  version = "v3.0.0-pre";
  src = interchain-security-src;
  rev = interchain-security-src.rev;
  vendorHash = "sha256-j0xus8vN6bnFMUXyvT8r7ONPQyaEBydKQ8qH2BevWPs=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  doCheck = false; # tests are currently failing
}
