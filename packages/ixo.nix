{
  buildGoModule,
  ixo-src,
}:
buildGoModule {
  name = "ixo";
  version = "v0.18.0-rc1";
  src = ixo-src;
  vendorSha256 = "sha256-g6dKujkFZLpFGpxgzb7v1YOo4cdeP6eEAbUjMzAIkF8=";
  tags = ["netgo"];
  engine = "tendermint/tendermint";
  doCheck = false;
}
