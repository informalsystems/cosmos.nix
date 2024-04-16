{
  inputs,
  mkCosmosGoApp,
  cosmosLib,
  libwasmvm_1_5_2,
}:
with inputs;
  builtins.mapAttrs (_: mkCosmosGoApp)
  {
    stride-consumer = {
      name = "stride-consumer";
      version = "v21.0.0";
      goVersion = "1.21";
      src = stride-consumer-src;
      rev = stride-consumer-src.rev;
      vendorHash = "sha256-N3+H90djql3pqyvKM9nlq2XIxUDw7lt9xtWYiKBabro=";
      engine = "cometbft/cometbft";

      preFixup = ''
        ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "strided"}
      '';
      buildInputs = [libwasmvm_1_5_2];

      doCheck = false;
    };

    stride-consumer-no-admin = {
      name = "stride-consumer-no-admin";
      version = "v21.0.0";
      goVersion = "1.21";
      src = stride-consumer-src;
      rev = stride-consumer-src.rev;
      vendorHash = "sha256-N3+H90djql3pqyvKM9nlq2XIxUDw7lt9xtWYiKBabro=";
      engine = "cometbft/cometbft";

      preFixup = ''
        ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "strided"}
      '';
      buildInputs = [libwasmvm_1_5_2];

      patches = [../patches/stride-no-admin-check.patch];
      doCheck = false;
    };
  }
