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
        engine = "tendermint/tendermint";
      };

      ibc-go-v3-simapp = {
        name = "simapp";
        version = "v3.3.0";
        src = ibc-go-v3-src;
        vendorSha256 = "sha256-jI1Ky8SzwZ3PhAZrDJQknAWUnu0G9rktAyaE4J/o8Cw=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
      };

      ibc-go-v4-simapp = {
        name = "simapp";
        version = "v4.2.0";
        src = ibc-go-v4-src;
        vendorSha256 = "sha256-M8N6IPBnhOQp4LsCgdKc0NOtdeLNkAcXtGsvHS00D+g=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
      };

      ibc-go-v5-simapp = {
        name = "simapp";
        version = "v5.1.0";
        src = ibc-go-v5-src;
        vendorSha256 = "sha256-KajTi+hCMM8AoLsGmWV7qVGbYA8vZhn+0tmG20zJgPI=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        excludedPackages = ["./e2e"];
      };

      ibc-go-v6-simapp = {
        name = "simapp";
        version = "v6.1.0";
        src = ibc-go-v6-src;
        vendorSha256 = "sha256-hP/DTNkB1NI7yZZDn5tYy/9jYIb3BqESxIG2A4wgjJU";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        excludedPackages = ["./e2e"];
      };

      # If the modules/apps/callbacks is needed, it must be defined in a separate nix
      # package that loads only the given subdirectory as source
      ibc-go-v7-simapp = {
        name = "simd";
        version = "v7.3.0";
        src = inputs.ibc-go-v7-src;
        vendorSha256 = "sha256-Wn7krfvF7E93g4KnGZ8iXaSjc+kmGgQ8Jb5egWNMQg8=";
        goVersion = "1.20";
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        excludedPackages = ["./e2e" "./modules/apps/callbacks"];
      };

      # If the modules/apps/callbacks and/or modules/capability are needed,
      # they must each be defined in a separate nix package that loads only
      # the given subdirectory as source
      ibc-go-v8-simapp = {
        name = "simd";
        version = "v8.0.0-beta.1";
        src = inputs.ibc-go-v8-src;
        vendorSha256 = "sha256-vUj5rwsA7RQfip/LktWG+MdazYfux6zpFN7L/AGdHo0=";
        goVersion = "1.21";
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        excludedPackages = ["./e2e" "./modules/apps/callbacks" "./modules/capability"];
      };

      # If the modules/apps/callbacks and/or modules/capability are needed,
      # they must each be defined in a separate nix package that loads only
      # the given subdirectory as source
      ibc-go-v8-channel-upgrade-simapp = {
        name = "simd";
        version = "channel-upgrade-alpha.0";
        src = inputs.ibc-go-v8-channel-upgrade-src;
        vendorSha256 = "sha256-FOCQcn9r7mmpjY9h4gvwcRqL4qhu3wkXsx1KM1n17Cg=";
        goVersion = "1.21";
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        doCheck = false;
        excludedPackages = ["./e2e" "./modules/apps/callbacks" "./modules/capability"];
      };
    }
