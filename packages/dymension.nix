{
  mkCosmosGoApp,
  dymension-src,
}:
mkCosmosGoApp {
  name = "dymension";
  version = "v3.0.0";
  src = "${dymension-src}";
  rev = dymension-src.rev;
  vendorHash = "sha256-2mDEDtFN0T6430owWxPl+zLl/BaJaNDMA//RUBtncbs=";
  tags = ["netgo"];
  goVersion = "1.21";
  engine = "cometbft/cometbft";
  doCheck = false;
}
