{buildGoModule, cometbft-src}:
      buildGoModule {
        name = "cometbft";
        src = cometbft-src;
        vendorHash = "sha256-rZeC0B5U0bdtZAw/hnMJ7XG73jN0nsociAN8GGdmlUY=";
        doCheck = false;
      }
