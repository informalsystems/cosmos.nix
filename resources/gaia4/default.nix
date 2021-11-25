{ pkgs, gaia4-src, ledgerSupport ? false }:
let
  pname = "gaia";
  version = "v4.2.1";
  tendermint-version = (fromTOML (builtins.readFile ./go-modules.toml))."github.com/tendermint/tendermint".sumVersion;
in
pkgs.buildGoApplication {
  inherit pname version;
  src = "${gaia4-src}";
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
    -X github.com/cosmos/cosmos-sdk/version.Commit=${gaia4-src.rev}
    -X github.com/tendermint/tendermint/version.TMCoreSemVer=${tendermint-version}
  '';
}

