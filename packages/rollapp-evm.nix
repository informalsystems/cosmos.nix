{
  mkCosmosGoApp,
  rollapp-evm-src,
}:
mkCosmosGoApp {
  name = "rollapp-evm";
  version = "v2.0.0-beta-7-g21b29f6";
  src = "${rollapp-evm-src}";
  rev = rollapp-evm-src.rev;
  vendorHash = "sha256-2mDEDtFN0T6430owWxPl+zLl/BaJaNDMA//RUBtncbs=";
  tags = ["netgo"];
  goVersion = "1.21";
  engine = "cometbft/cometbft";
  doCheck = false;
}
