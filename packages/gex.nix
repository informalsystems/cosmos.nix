{
  pkgs,
  gex-src,
}:
pkgs.buildGoModule {
  name = "gex";
  doCheck = false;
  src = gex-src;
  vendorSha256 = "sha256-3vD0ge0zWSnGoeh5FAFEw60a7q5/YWgDsGjjgibBBNI=";
}
