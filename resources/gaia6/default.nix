{ pkgs, gaia6-src }:
let
  version = "v6.0.0-rc3";
  tendermint-version = (fromTOML (builtins.readFile ./go-modules.toml))."github.com/tendermint/tendermint".sumVersion;
  pname = "gaia";
in
pkgs.buildGoApplication {
  inherit version pname;
  src = "${gaia6-src}";
  modules = ./go-modules.toml;
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
  buildFlagsArray = ''
    -ldflags=
    -X github.com/cosmos/cosmos-sdk/version.Name=${pname}
    -X github.com/cosmos/cosmos-sdk/version.AppName=gaiad
    -X github.com/cosmos/cosmos-sdk/version.Version=${version}
    -X github.com/cosmos/cosmos-sdk/version.Commit=${gaia6-src.rev}
    -X github.com/tendermint/tendermint/version.TMCoreSemVer=${tendermint-version}
  '';
}

