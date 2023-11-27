{ buildGoModule, cosmos-sdk-src }:
      buildGoModule {
        name = "cosmovisor";
        src = "${cosmos-sdk-src}/cosmovisor";
        vendorHash = "sha256-APJ+mt8e2zHiO/8UI7Zt63P5HFxEG2ogLf5uxfp58cQ=";
        doCheck = false;
      }
