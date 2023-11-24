{ cosmosLib, osmosis-src, libwasmvm_1_2_3 }:
      cosmosLib.mkCosmosGoApp {
        name = "osmosis";
        version = "v19.2.0";
        src = osmosis-src;
        vendorSha256 = "sha256-z1lGckpsrCui8VQow3ciy6yl5LL5NxHMIU+SGL9wvKs=";
        tags = ["netgo"];
        excludedPackages = ["cl-genesis-positions"];
        engine = "tendermint/tendermint";
        preFixup = ''
          ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_2_3 "osmosisd"}
          ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_2_3 "chain"}
          ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_2_3 "node"}
        '';
        buildInputs = [libwasmvm_1_2_3];
        proxyVendor = true;

        # Test has to be skipped as end-to-end testing requires network access
        doCheck = false;
      }
