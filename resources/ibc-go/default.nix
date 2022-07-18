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
        version = "v2.0.0";
        vendorSha256 = "sha256-Af47uEEPCFsX1JiMiw3LprGDiVb/0HA0sMeuDdAVXu8=";
        tags = ["netgo"];
      };

      ibc-go-v3-simapp = {
        name = "simapp";
        version = "v3.0.0";
        src = ibc-go-v3-src;
        vendorSha256 = "sha256-kefoBLr1pbyycUjel6rZ8VsqCLbPFY5hUHUVyO+Y2wc=";
        tags = ["netgo"];
      };

      ibc-go-v4-simapp = {
        name = "simapp";
        version = "v4.0.0";
        src = ibc-go-v4-src;
        vendorSha256 = "sha256-7NJoasvGMUtJqZpqLDm6+aVrKQw3VYO/13udb8wKz5s=";
        tags = ["netgo"];
      };

      ibc-go-main-simapp = {
        name = "simapp";
        version = "v4.0.0-main";
        src = ibc-go-main-src;
        vendorSha256 = "sha256-7NJoasvGMUtJqZpqLDm6+aVrKQw3VYO/13udb8wKz5s=";
        tags = ["netgo"];
      };
    }
