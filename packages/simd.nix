{
  buildGoModule,
  cosmos-sdk-src,
}:
buildGoModule {
  name = "simd";
  src = cosmos-sdk-src;
  vendorHash = "sha256-ZlfvpnaF/SBHeXW2tzO3DVEyh1Uh4qNNXBd+AoWd/go=";
  doCheck = false;
  excludedPackages = [
    "./client/v2"
    "./cosmovisor"
    "./container"
    "./core"
    "./db"
    "./errors"
    "./math"
    "./orm"
    "./store/tools"
  ];
  ldflags = [
    "-X github.com/cosmos/cosmos-sdk/version.AppName=simd"
    "-X github.com/cosmos/cosmos-sdk/version.Version=v0.46.0"
    "-X github.com/cosmos/cosmos-sdk/version.Commit=${cosmos-sdk-src.rev}"
  ];
}
