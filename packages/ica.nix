{
  buildGoModule,
  ica-src,
}:
buildGoModule {
  name = "ica";
  src = ica-src;
  vendorSha256 = "sha256-ZIP6dmHugLLtdA/8N8byg3D3JinjNxpvxyK/qiIs7bI=";
}
