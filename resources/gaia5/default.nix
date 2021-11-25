{ pkgs, gaia5-src, ledgerSupport ? false }:
let
  pname = "gaia";
  version = "v5.0.6";
  tendermint-version = (fromTOML (builtins.readFile ./go-modules.toml))."github.com/tendermint/tendermint".sumVersion;
in
pkgs.buildGoApplication {
  inherit pname version;
  src = "${gaia5-src}";
  modules = ./go-modules.toml;
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
  buildFlags = "-tags netgo" + pkgs.lib.optionalString ledgerSupport ",ledger";
  buildFlagsArray = ''
    -ldflags=
    -X github.com/cosmos/cosmos-sdk/version.Name=${pname}
    -X github.com/cosmos/cosmos-sdk/version.AppName=gaiad
    -X github.com/cosmos/cosmos-sdk/version.Version=${version}
    -X github.com/cosmos/cosmos-sdk/version.Commit=${gaia5-src.rev}
    -X github.com/tendermint/tendermint/version.TMCoreSemVer=${tendermint-version}
  '';
}

