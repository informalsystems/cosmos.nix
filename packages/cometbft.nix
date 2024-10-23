{
  buildGoModule,
  cometbft-src,
}:
buildGoModule {
  name = "cometbft";
  src = cometbft-src;
  vendorHash = "sha256-bQseXRiRup7g7TChMRC3K8tjFLgyqzLWxT9LgsXQnqw=";
  doCheck = false;
}
