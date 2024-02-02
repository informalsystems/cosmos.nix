{
  mkCosmosGoApp,
  berachain-src,
}:
mkCosmosGoApp {
  name = "berachain";
  version = "v0.1.0-alpha";
  src = "${berachain-src}/cosmos";
  rev = berachain-src.rev;
  vendorHash = "sha256-5T22V4CU3K/8WuJtlHnbCeymIWTBCUzaHb4sBZhS8ms=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  goVersion = "1.21";
}
