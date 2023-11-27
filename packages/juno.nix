{cosmosLib, juno-src, libwasmvm_1_1_1}:
      cosmosLib.mkCosmosGoApp {
        name = "juno";
        version = "v13.0.1";
        src = juno-src;
        vendorSha256 = "sha256-0EsEzkEY4N4paQ+OPV7MVUTwOr8F2uCCLi6NQ3JSlgM=";
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        preFixup = ''
          ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_1_1 "junod"}
          ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_1_1 "chain"}
          ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_1_1 "node"}
        '';
        dontStrip = true;
        buildInputs = [libwasmvm_1_1_1];
      }
