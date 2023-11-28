{
  mkCosmosGoApp,
  crescent-src,
}:
mkCosmosGoApp {
  name = "crescent";
  version = "v1.0.0-rc3";
  src = crescent-src;
  vendorSha256 = "sha256-WLLQKXjPRhK19oEdqp2UBZpi9W7wtYjJMj07omH41K0=";
  tags = ["netgo"];
  engine = "tendermint/tendermint";
  additionalLdFlags = ''
    -X github.com/cosmos/cosmos-sdk/types.reDnmString=[a-zA-Z][a-zA-Z0-9/:]{2,127}
  '';
}
