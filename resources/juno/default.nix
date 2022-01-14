{ pkgs, juno-src, ledgerSupport ? false }:
let
  pname = "juno";
  version = "v2.1.0";
  tendermint-version = (fromTOML (builtins.readFile ./go-modules.toml))."github.com/tendermint/tendermint".sumVersion;
in
pkgs.buildGoApplication {
  name = "juno";
  src = "${juno-src}";
  modules = ./go-modules.toml;
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
  doCheck = false;
  CGO_ENABLED = "1";
  buildFlags = "-tags netgo" + pkgs.lib.optionalString ledgerSupport ",ledger";
  buildFlagsArray = ''
    -ldflags=
    -X github.com/cosmos/cosmos-sdk/version.Name=${pname}
    -X github.com/cosmos/cosmos-sdk/version.AppName=junod
    -X github.com/cosmos/cosmos-sdk/version.Version=${version}
    -X github.com/cosmos/cosmos-sdk/version.Commit=${juno-src.rev}
    -X github.com/tendermint/tendermint/version.TMCoreSemVer=${tendermint-version}
  '';
}
