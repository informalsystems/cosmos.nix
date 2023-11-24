{mkCosmosGoApp, evmos-src}:
      mkCosmosGoApp.mkCosmosGoApp {
        name = "evmos";
        version = "v9.1.0";
        src = evmos-src;
        vendorSha256 = "sha256-AjWuufyAz5KTBwKiWvhPeqGm4fn3MUqg39xb4pJ0hTM=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
      }
