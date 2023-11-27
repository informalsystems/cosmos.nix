{mkCosmosGoApp, regen-src}:
      mkCosmosGoApp {
        name = "regen-ledger";
        version = "v3.0.0";
        subPackages = ["app/regen"];
        src = regen-src;
        vendorSha256 = "sha256-IdxIvL8chuGD71q4V7c+RWZ7PoEAVQ7++Crdlz2q/XI=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
      }
