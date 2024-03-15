{
  ignite-cli-src,
  buildGoModule,
}:
buildGoModule rec {
  name = "ignite-cli";
  src = ignite-cli-src;
  vendorHash = "sha256-P1NYgvdobi6qy1sSKFwkBwPRpLuvCJE5rCD2s/vvm14=";
  doCheck = false;
  ldflags = [
    "-X github.com/ignite/cli/ignite/version.Head=${src.rev}"
    "-X github.com/ignite/cli/ignite/version.Version=v0.24.0"
    "-X github.com/ignite/cli/ignite/version.Date=${builtins.toString (src.lastModified ? "0")}"
  ];
}
