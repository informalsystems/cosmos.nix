{ pkgs, inputs }:
let
  parser = import ../goModParser.nix;

  gaia6_0_4 = {
    name = "gaia";
    vendorSha256 = "sha256-KeF3gO5sUJEXWqb6EVYBYXpVBfhvyXZ4f03l63wYTjE=";
    version = "v6.0.4";
    src = inputs.gaia6_0_4-src;
    ledgerSupport = false;
  };
in
builtins.mapAttrs
  (
    _: { name, version, src, ledgerSupport, vendorSha256 }:
      let
        go-mod = parser (builtins.readFile "${src}/go.mod");
        tendermint-version = go-mod.require."github.com/tendermint/tendermint".version;
      in
      pkgs.buildGoModule {
        inherit version src vendorSha256;
        pname = name;
        doCheck = false;
        preCheck = ''
          export HOME="$(mktemp -d)"
        '';
        tags = [ "netgo" ] ++ (if ledgerSupport then [ "ledger" ] else [ ]);
        ldflags = ''
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
    name = "gaia";
    vendorSha256 = "sha256-e8/xrLwzZ4/B2Rr/+e8n6iAm6PQxcEynL9wLYD3jKY4=";
    version = "v4.2.1";
    src = inputs.gaia4-src;
    ledgerSupport = false;
  };

  gaia5 = {
    name = "gaia";
    vendorSha256 = "sha256-V0DMuwKeCYpVlzF9g3cQD6YViJZQZeoszxbUqrUyQn4=";
    version = "v5.0.6";
    src = inputs.gaia5-src;
    ledgerSupport = false;
  };

  gaia6 = gaia6_0_4;

  inherit gaia6_0_4;

  gaia6_0_3 = {
    name = "gaia";
    vendorSha256 = "sha256-cNQOv4wW98Vd08ieU3jgsvXoSDQQYZTkeTqUD2Cty58=";
    version = "v6.0.3";
    src = inputs.gaia6_0_3-src;
    ledgerSupport = false;
  };

  gaia6_0_2 = {
    name = "gaia";
    vendorSha256 = "sha256-CNxWgIWf+8wB2CAUk+WadnIb3fi1UYftPea5sWtk/Rs=";
    version = "v6.0.2";
    src = inputs.gaia6_0_2-src;
    ledgerSupport = false;
  };
  gaia7 = {
    name = "gaia";
    vendorSha256 = "sha256-G+iqzfy1dlaTsGuxq0ffXgEI4RJ7ZwbU8GlTWKXp/sU=";
    version = "v7.0.0-rc0";
    src = inputs.gaia7-src;
    ledgerSupport = false;
  };
  ibc-go-v2-simapp = {
    name = "simapp";
    src = inputs.ibc-go-v2-src;
    version = "v6.0.0-v3";
    vendorSha256 = "sha256-Af47uEEPCFsX1JiMiw3LprGDiVb/0HA0sMeuDdAVXu8=";
    ledgerSupport = false;
  };
  ibc-go-v3-simapp = {
    name = "simapp";
    version = "v6.0.0-v3";
    src = inputs.ibc-go-v3-src;
    vendorSha256 = "sha256-W05fH/y7InNgY68aJLlm32c8DpAKFnO3ehH8CzzYdPI=";
    ledgerSupport = false;
  };
  ibc-go-ics29-simapp = {
    name = "simapp";
    version = "v6.0.0-ics29";
    src = inputs.ibc-go-ics29-src;
    vendorSha256 = "sha256-e2aA/mme24hi3ERl/ooZc1YsshlvHmXak/VEwGe5Q3I=";
    ledgerSupport = false;
  };
}
