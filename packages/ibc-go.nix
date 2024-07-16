{
  inputs,
  mkCosmosGoApp,
}:
with inputs;
  builtins.mapAttrs (_: mkCosmosGoApp)
  {
    ibc-go-v2-simapp = {
      name = "simapp";
      src = ibc-go-v2-src;
      rev = ibc-go-v2-src.rev;
      version = "v2.4.1";
      vendorHash = "sha256-edKJYHKYOkpdXs1xHEdFjlNT1m4IhhhyyzIKjYvhE38=";
      tags = ["netgo"];
      engine = "tendermint/tendermint";
    };

    ibc-go-v3-simapp = {
      name = "simapp";
      version = "v3.3.0";
      src = ibc-go-v3-src;
      rev = ibc-go-v3-src.rev;
      vendorHash = "sha256-jI1Ky8SzwZ3PhAZrDJQknAWUnu0G9rktAyaE4J/o8Cw=";
      tags = ["netgo"];
      engine = "tendermint/tendermint";
    };

    ibc-go-v4-simapp = {
      name = "simapp";
      version = "v4.6.0";
      src = ibc-go-v4-src;
      rev = ibc-go-v4-src.rev;
      vendorHash = "sha256-1BrGCK/TtJFEvHf7C7OXvwNRxeCJejM17Jq7a3JVlnk=";
      tags = ["netgo"];
      engine = "tendermint/tendermint";
    };

    ibc-go-v5-simapp = {
      name = "simapp";
      version = "v5.4.0";
      src = ibc-go-v5-src;
      rev = ibc-go-v5-src.rev;
      vendorHash = "sha256-k1YaGedNUv1fjXNfYjDAfcX8KqviHhWFreqjYHXQoJs=";
      tags = ["netgo"];
      engine = "tendermint/tendermint";
      excludedPackages = ["./e2e"];
    };

    ibc-go-v6-simapp = {
      name = "simapp";
      version = "v6.3.0";
      src = ibc-go-v6-src;
      rev = ibc-go-v6-src.rev;
      vendorHash = "sha256-IA6W9MaiDi/4wPDXIVO/6xPJwduBwgLiq/yv1zHFBMc=";
      tags = ["netgo"];
      engine = "tendermint/tendermint";
      excludedPackages = ["./e2e"];
    };

    # If the modules/apps/callbacks is needed, it must be defined in a separate nix
    # package that loads only the given subdirectory as source
    ibc-go-v7-simapp = {
      name = "simd";
      version = "v7.4.0";
      src = ibc-go-v7-src;
      rev = ibc-go-v7-src.rev;
      vendorHash = "sha256-zjk/75+e/gWSCvpz7lrZkNEDigC/x8czpCSxxbSmWXg=";
      tags = ["netgo"];
      engine = "cometbft/cometbft";
      excludedPackages = ["./e2e" "./modules/apps/callbacks"];
    };

    # If the modules/apps/callbacks and/or modules/capability are needed,
    # they must each be defined in a separate nix package that loads only
    # the given subdirectory as source
    ibc-go-v8-simapp = {
      name = "simd";
      version = "v8.3.1";
      src = ibc-go-v8-src;
      rev = ibc-go-v8-src.rev;
      vendorHash = "sha256-SZPjD/7KCmTtlhRV6XdwPG5ArB67mpuJkcSukGKBRPM=";
      goVersion = "1.21";
      tags = ["netgo"];
      engine = "cometbft/cometbft";
      excludedPackages = ["./e2e" "./modules/apps/callbacks" "./modules/capability"];
    };

    ibc-go-v8-polymer-multihop-simapp = {
      name = "simd";
      version = "v8-polymer-multihop";
      src = ibc-go-v8-polymer-multihop-src;
      rev = ibc-go-v8-polymer-multihop-src.rev;
      vendorHash = "sha256-qgDne2dHs94D4jgp2RhwDJYf+Ki5DrKqJGDVOEBiiT0=";
      goVersion = "1.21";
      tags = ["netgo"];
      engine = "cometbft/cometbft";
      excludedPackages = ["./e2e" "./modules/apps/callbacks" "./modules/capability" "./modules/light-clients/08-wasm"];
      doCheck = false;
    };
  }
