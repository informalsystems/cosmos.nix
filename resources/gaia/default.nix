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
      gaia-main = {
        name = "gaia";
        vendorSha256 = "sha256-V0DMuwKeCYpVlzF9g3cQD6YViJZQZeoszxbUqrUyQn4=";
        version = "v8.0.0";
        src = gaia5-src;
        tags = ["netgo"];
      };

      gaia5 = {
        name = "gaia";
        vendorSha256 = "sha256-V0DMuwKeCYpVlzF9g3cQD6YViJZQZeoszxbUqrUyQn4=";
        version = "v5.0.6";
        src = gaia5-src;
        tags = ["netgo"];
      };

      gaia6 = {
        name = "gaia";
        vendorSha256 = "sha256-KeF3gO5sUJEXWqb6EVYBYXpVBfhvyXZ4f03l63wYTjE=";
        version = "v6.0.4";
        src = gaia6-src;
        tags = ["netgo"];
      };

      gaia6-ordered = {
        name = "gaia";
        vendorSha256 = "sha256-4gBFn+zY3JK2xGKdIlYgRbK3WWjmtKFdEaUc1+nT4zw=";
        version = "v6.0.4-ordered";
        src = gaia6-ordered-src;
        tags = ["netgo"];
      };

      gaia7 = {
        name = "gaia";
        vendorSha256 = "sha256-rohPqCjPC3yr8wDNpndbhP6t7AgjY+kyqRGJYApCMgs=";
        version = "v7.0.3";
        src = gaia7-src;
        tags = ["netgo"];

        # Tests have to be disabled because they require Docker to run
        doCheck = false;
      };
    }
