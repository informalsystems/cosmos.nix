{
  mkCosmosGoApp,
  evmos-src,
  pkgs,
}:
mkCosmosGoApp {
  name = "evmos";
  version = "v16.0.0-rc4";
  src = evmos-src;
  goVersion = "1.21";
  buildInputs = with pkgs; [ gcc ];
  nativBuildInputs = with pkgs; [ gcc ];
  vendorHash = "sha256-HvBCGbo71VfBg0ivdP2GPG7LEPGEDN4lPgEo7ehJNcU=";
  engine = "cometbft/cometbft";
}
