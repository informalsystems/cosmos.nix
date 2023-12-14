{
  buildGoModule,
  gex-src,
}:
buildGoModule {
  name = "gex";
  doCheck = false;
  src = gex-src;
  vendorHash = "sha256-3vD0ge0zWSnGoeh5FAFEw60a7q5/YWgDsGjjgibBBNI=";
}
