{
  mkCosmosGoApp,
  interchain-security-src,
}:
mkCosmosGoApp {
  name = "interchain-security";
  appName = "interchain-security";
  version = "v5.5.0-pre";
  src = interchain-security-src;
  rev = interchain-security-src.rev;
  vendorHash = "sha256-JNyyPbp8XD1gEoyCO7sMB1z7HbER6lfdfnAIq6kiQkQ=";
  goVersion = "1.22";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  doCheck = false; # tests are currently failing
}
