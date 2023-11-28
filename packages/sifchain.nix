{
  mkCosmosGoApp,
  sifchain-src,
}:
mkCosmosGoApp {
  name = "sifchain";
  version = "v0.12.1";
  src = sifchain-src;
  vendorSha256 = "sha256-AX5jLfH9RnoGZm5MVyM69NnxVjYMR45CNaKzQn5hsXg=";
  tags = ["netgo"];
  engine = "tendermint/tendermint";
  additionalLdFlags = ''
    -X github.com/cosmos/cosmos-sdk/version.ServerName=sifnoded
    -X github.com/cosmos/cosmos-sdk/version.ClientName=sifnoded
  '';
  appName = "sifnoded";
  doCheck = false;
}
