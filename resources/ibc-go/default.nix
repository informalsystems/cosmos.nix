{ pkgs, inputs }:
let
  mkCosmosGoApp = (import ../utilities.nix { inherit pkgs; }).mkCosmosGoApp;
in
builtins.mapAttrs
  (_: mkCosmosGoApp)
{
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
