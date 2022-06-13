{
  pkgs,
  inputs,
}: let
  mkCosmosGoApp = (import ../utilities.nix {inherit pkgs;}).mkCosmosGoApp;
in
  with inputs;
    builtins.mapAttrs
    (_: mkCosmosGoApp)
    {
      ibc-go-v2-simapp = {
        name = "simapp";
        src = ibc-go-v2-src;
        version = "v6.0.0-v3";
        vendorSha256 = "sha256-Af47uEEPCFsX1JiMiw3LprGDiVb/0HA0sMeuDdAVXu8=";
        tags = ["netgo"];
      };

      ibc-go-v3-simapp = {
        name = "simapp";
        version = "v6.0.0-v3";
        src = ibc-go-v3-src;
        vendorSha256 = "sha256-W05fH/y7InNgY68aJLlm32c8DpAKFnO3ehH8CzzYdPI=";
        tags = ["netgo"];
      };

      ibc-go-main-simapp = {
        name = "simapp";
        version = "v7.0.0-main";
        src = ibc-go-main-src;
        vendorSha256 = "sha256-nkL4aJuu459yg60yfCexMrt13P18pmaRrHmM12JVfig=";
        tags = ["netgo"];
      };

      ibc-go-ics29-simapp = {
        name = "simapp";
        version = "v7.0.0-ics29-beta2";
        src = ibc-go-ics29-src;
        vendorSha256 = "sha256-2RBZNUIZVdPPI63FzkmOOPSlYlFE+UjzMMnqKEjayNY=";
        tags = ["netgo"];
      };
    }
