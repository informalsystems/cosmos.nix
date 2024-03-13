{
  mkCosmosGoApp,
  rollapp-evm-src,
}:
mkCosmosGoApp {
  name = "rollapp-evm";
  version = "v2.0.0-beta-7-g21b29f6";
  src = rollapp-evm-src;
  rev = rollapp-evm-src.rev;
  vendorHash = "sha256-rg3ZrNIMuUUW01lyjklTxn4zYlOiwFXyTqSE7scaRAk=";
  tags = ["netgo"];
  goVersion = "1.20";
  engine = "cometbft/cometbft";
}
