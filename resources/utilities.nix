{pkgs}: {
  mkCosmosGoApp = {
    name,
    version,
    src,
    ledgerSupport,
    vendorSha256,
    doCheck ? true,
    appName ? null,
    preCheck ? null,
  }: let
    parser = import ./goModParser.nix;
    go-mod = parser (builtins.readFile "${src}/go.mod");
    tendermint-version = go-mod.require."github.com/tendermint/tendermint".version;
    ldFlagAppName =
      if appName == null
      then "${name}d"
      else appName;
  in
    pkgs.buildGoModule {
      inherit version src vendorSha256 doCheck;
      pname = name;
      tags =
        ["netgo"]
        ++ (
          if ledgerSupport
          then ["ledger"]
          else []
        );
      preCheck =
        if preCheck == null
        then ''export HOME="$(mktemp -d)"''
        else preCheck;
      ldflags = ''
        -X github.com/cosmos/cosmos-sdk/version.Name=${name}
        -X github.com/cosmos/cosmos-sdk/version.AppName=${ldFlagAppName}
        -X github.com/cosmos/cosmos-sdk/version.Version=${version}
        -X github.com/cosmos/cosmos-sdk/version.Commit=${src.rev}
        -X github.com/tendermint/tendermint/version.TMCoreSemVer=${tendermint-version}
      '';
    };
}
