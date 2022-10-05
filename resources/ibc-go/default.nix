{
  pkgs,
  inputs,
}: let
  mkCosmosGoApp =
    (import ../utilities.nix {
      inherit pkgs;
      inherit (inputs) nix-std;
    })
    .mkCosmosGoApp;
in
  with inputs;
    builtins.mapAttrs
    (_: mkCosmosGoApp)
    {
      ibc-go-v2-simapp = {
        name = "simapp";
        src = ibc-go-v2-src;
        version = "v2.4.1";
        vendorSha256 = "sha256-edKJYHKYOkpdXs1xHEdFjlNT1m4IhhhyyzIKjYvhE38=";
        tags = ["netgo"];
      };

      ibc-go-v3-simapp = {
        name = "simapp";
        version = "v3.3.0";
        src = ibc-go-v3-src;
        vendorSha256 = "sha256-jI1Ky8SzwZ3PhAZrDJQknAWUnu0G9rktAyaE4J/o8Cw=";
        tags = ["netgo"];
      };

      ibc-go-v4-simapp = {
        name = "simapp";
        version = "v4.1.0";
        src = ibc-go-v4-src;
        vendorSha256 = "sha256-jI1Ky8SzwZ3PhAZrDJQknAWUnu0G9rktAyaE4J/o8Cw=";
        tags = ["netgo"];
      };

      ibc-go-v5-simapp = {
        name = "simapp";
        version = "v5.0.0";
        src = ibc-go-v5-src;
        vendorSha256 = "sha256-hxffp0n0kchyUb6T4UzXqUZKGH4t4aHjuQhFQUjeUgA=";
        tags = ["netgo"];
        excludedPackages = ["./e2e"];
      };

      ibc-go-v6-simapp = {
        name = "simapp";
        version = "v6.0.0";
        src = ibc-go-v6-src;
        vendorSha256 = "sha256-hxffp0n0kchyUb6T4UzXqUZKGH4t4aHjuQhFQUjeUgA=";
        tags = ["netgo"];
        excludedPackages = ["./e2e"];
      };
    }
