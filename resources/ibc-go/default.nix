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
        version = "v2.3.1";
        vendorSha256 = "sha256-T/hfztDtgG5RLxrTozhCXwT6IQag3RQbIRSNeCfjLGA=";
        tags = ["netgo"];
      };

      ibc-go-v3-simapp = {
        name = "simapp";
        version = "v3.1.1";
        src = ibc-go-v3-src;
        vendorSha256 = "sha256-pFe1Jn/wOuT71Vqw0Vxk2sneVTLXb+wrLfB8ObmFWnw=";
        tags = ["netgo"];
      };

      ibc-go-v4-simapp = {
        name = "simapp";
        version = "v4.0.0";
        src = ibc-go-v4-src;
        vendorSha256 = "sha256-pFe1Jn/wOuT71Vqw0Vxk2sneVTLXb+wrLfB8ObmFWnw=";
        tags = ["netgo"];
      };

      ibc-go-v5-simapp = {
        name = "simapp";
        version = "v5.0.0";
        src = ibc-go-v5-src;
        vendorSha256 = "sha256-vPkvYrdk5yOC/imtDobHSFWSXmvT7vfHpe0WGoxZ490=";
        tags = ["netgo"];
        excludedPackages = ["./e2e"];
      };
    }
