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
        version = "v2.3.1";
        vendorSha256 = "sha256-B1ZAnE62cqRte0hvSCWtsc5zD5moeN8x/beLgBhpvIw=";
        tags = ["netgo"];
      };

      ibc-go-v3-simapp = {
        name = "simapp";
        version = "v3.1.1";
        src = ibc-go-v3-src;
        vendorSha256 = "sha256-jN2qO+jmCouc5/s/yx4hhfKZkvZuK/ii6j+Hvxfh7sM=";
        tags = ["netgo"];
      };

      ibc-go-v4-simapp = {
        name = "simapp";
        version = "v4.0.0";
        src = ibc-go-v4-src;
        vendorSha256 = "sha256-7NJoasvGMUtJqZpqLDm6+aVrKQw3VYO/13udb8wKz5s=";
        tags = ["netgo"];
      };

      ibc-go-v5-simapp = {
        name = "simapp";
        version = "v5.0.0";
        src = ibc-go-v5-src;
        vendorSha256 = "sha256-vPkvYrdk5yOC/imtDobHSFWSXmvT7vfHpe0WGoxZ490=";
        tags = ["netgo"];
        patchPhase = ''
          rm -r e2e
        '';
      };
    }
