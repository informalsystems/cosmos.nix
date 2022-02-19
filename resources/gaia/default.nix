{ pkgs, gaia4-src, gaia5-src, gaia6-src, gaia6-ordered-src }:
let
  parser = import ../goModParser.nix;
in
builtins.mapAttrs
  (
    _: { version, src, ledgerSupport, vendorSha256 }:
      let
        go-mod = parser (builtins.readFile "${src}/go.mod");
        tendermint-version = go-mod.require."github.com/tendermint/tendermint".version;
      in
      pkgs.buildGoModule {
        inherit version src vendorSha256;
        pname = "gaia";
        preCheck = ''
          export HOME="$(mktemp -d)"
        '';
        buildFlags = "-tags netgo" + pkgs.lib.optionalString ledgerSupport ",ledger";
        buildFlagsArray = ''
          -ldflags=
          -X github.com/cosmos/cosmos-sdk/version.Name=gaia
          -X github.com/cosmos/cosmos-sdk/version.AppName=gaiad
          -X github.com/cosmos/cosmos-sdk/version.Version=${version}
          -X github.com/cosmos/cosmos-sdk/version.Commit=${src.rev}
          -X github.com/tendermint/tendermint/version.TMCoreSemVer=${tendermint-version}
        '';
      }
  )
{
  gaia4 = {
    vendorSha256 = "sha256-e8/xrLwzZ4/B2Rr/+e8n6iAm6PQxcEynL9wLYD3jKY4=";
    version = "v4.2.1";
    src = gaia4-src;
    ledgerSupport = false;
  };

  gaia5 = {
    vendorSha256 = "sha256-V0DMuwKeCYpVlzF9g3cQD6YViJZQZeoszxbUqrUyQn4=";
    version = "v5.0.6";
    src = gaia5-src;
    ledgerSupport = false;
  };

  gaia6 = {
    vendorSha256 = "sha256-a0ps1vlnXIzke5JHqXyav+Jrp9j3d4ohtBq4AWy+uUI=";
    version = "v6.0.3";
    src = gaia6-src;
    ledgerSupport = false;
  };

  gaia6-ordered = {
    vendorSha256 = "sha256-Jtxa9SAj69iQWUbaM5YSxS8n3Sob7L/3Cf2j0SU5Q+s=";
    version = "v6.0.1-ordered";
    src = gaia6-ordered-src;
    ledgerSupport = false;
  };

}

