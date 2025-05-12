{
  mkCosmosGoApp,
  dydx-src,
}:
mkCosmosGoApp {
  name = "dydx";
  version = "v3.0.0-dev0";
  src = "${dydx-src}/protocol";
  rev = dydx-src.rev;
  moduleSubDir = "/protocol";
  vendorHash = "sha256-BwFD4IKk211dfLDKqQB1uixYIVada+KlWkBFEq6UDWc=";
  tags = ["netgo"];
  goVersion = "1.23";
  engine = "cometbft/cometbft";
  doCheck = false;
}
