{
  pkgs,
  inputs,
}: let
  mkCosmosGoApp = (import ../utilities.nix {inherit pkgs;}).mkCosmosGoApp;
in
  with inputs;
    builtins.mapAttrs
    (_: mkCosmosGoApp)
    rec {
      gaia5 = {
        name = "gaia";
        vendorSha256 = "sha256-V0DMuwKeCYpVlzF9g3cQD6YViJZQZeoszxbUqrUyQn4=";
        version = "v5.0.6";
        src = gaia5-src;
        tags = ["netgo"];
      };

      gaia6_0_2 = {
        name = "gaia";
        vendorSha256 = "sha256-CNxWgIWf+8wB2CAUk+WadnIb3fi1UYftPea5sWtk/Rs=";
        version = "v6.0.2";
        src = gaia6_0_2-src;
        tags = ["netgo"];
      };

      gaia6_0_3 = {
        name = "gaia";
        vendorSha256 = "sha256-cNQOv4wW98Vd08ieU3jgsvXoSDQQYZTkeTqUD2Cty58=";
        version = "v6.0.3";
        src = gaia6_0_3-src;
        tags = ["netgo"];
      };

      gaia6_0_4 = {
        name = "gaia";
        vendorSha256 = "sha256-KeF3gO5sUJEXWqb6EVYBYXpVBfhvyXZ4f03l63wYTjE=";
        version = "v6.0.4";
        src = gaia6_0_4-src;
        tags = ["netgo"];
      };

      gaia6-ordered = {
        name = "gaia";
        vendorSha256 = "sha256-4gBFn+zY3JK2xGKdIlYgRbK3WWjmtKFdEaUc1+nT4zw=";
        version = "v6.0.4-ordered";
        src = gaia6-ordered-src;
        tags = ["netgo"];
      };

      gaia6 = gaia6_0_4;

      gaia7 = {
        name = "gaia";
        vendorSha256 = "sha256-G+iqzfy1dlaTsGuxq0ffXgEI4RJ7ZwbU8GlTWKXp/sU=";
        version = "v7.0.0-rc0";
        src = gaia7-src;
        tags = ["netgo"];
      };
    }
