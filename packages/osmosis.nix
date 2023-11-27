{ cosmosLib, osmosis-src, libwasmvm_1_2_3 }:
      cosmosLib.mkCosmosGoApp {
        name = "osmosis";
        version = "v20.4.0";
        src = osmosis-src;
        vendorSha256 = "sha256-WN6H+lRS+wX4CiVEVMxp4fW2vtZxTi+O6SncJdrUFLo=";
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
