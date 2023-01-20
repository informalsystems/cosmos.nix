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
        version = "v4.2.0";
        src = ibc-go-v4-src;
        vendorSha256 = "sha256-M8N6IPBnhOQp4LsCgdKc0NOtdeLNkAcXtGsvHS00D+g=";
        tags = ["netgo"];
      };

      ibc-go-v5-simapp = {
        name = "simapp";
        version = "v5.1.0";
        src = ibc-go-v5-src;
        vendorSha256 = "sha256-KajTi+hCMM8AoLsGmWV7qVGbYA8vZhn+0tmG20zJgPI=";
        tags = ["netgo"];
        excludedPackages = ["./e2e"];
      };

      ibc-go-v6-simapp = {
        name = "simapp";
        version = "v6.1.0";
        src = ibc-go-v6-src;
        vendorSha256 = "sha256-hP/DTNkB1NI7yZZDn5tYy/9jYIb3BqESxIG2A4wgjJU";
        tags = ["netgo"];
        excludedPackages = ["./e2e"];
      };

      ibc-go-v7-simapp = {
        name = "simapp";
        version = "v7.0.0-pre.0";
        src = ibc-go-v7-src;
        vendorSha256 = "sha256-tTQ7kODkWvp9rSoP6yJ/JKuJkqvRh5klNNENC0CJMDM";
        tags = ["netgo"];
        excludedPackages = ["./e2e"];
      };
    }
