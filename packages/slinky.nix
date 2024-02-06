{
  mkCosmosGoApp,
  slinky-src,
}:
mkCosmosGoApp {
  name = "slinky";
  version = "v0.2.0";
  src = slinky-src;
  excludePackages = [ "./tests/integration" ];
  rev = slinky-src.rev;
  vendorHash = "sha256-vYSLryccpfY0QPqjGsplgJBkWnSbsCJN8wlycW27E1I=";
  tags = ["netgo"];
  goVersion = "1.21";
  engine = "cometbft/cometbft";
  doCheck = false;
}
