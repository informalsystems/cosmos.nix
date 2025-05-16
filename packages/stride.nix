{
  inputs,
  mkCosmosGoApp,
  cosmosLib,
  libwasmvm_1_5_2,
}:
with inputs;
  builtins.mapAttrs (_: mkCosmosGoApp)
  {
    stride = {
      name = "stride";
      version = "v23.0.1";
      goVersion = "1.23";
      src = stride-src;
      rev = stride-src.rev;
      vendorHash = "sha256-T1xdcD5ucMuAIMZdLrlBxkdWJF2Uirn7+lBpypf6q98=";
      engine = "cometbft/cometbft";

      preFixup = ''
        ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "strided"}
      '';
      buildInputs = [libwasmvm_1_5_2];

      doCheck = false;
    };

    stride-no-admin = {
      name = "stride-no-admin";
      version = "v23.0.1";
      goVersion = "1.23";
      src = stride-src;
      rev = stride-src.rev;
      vendorHash = "sha256-T1xdcD5ucMuAIMZdLrlBxkdWJF2Uirn7+lBpypf6q98=";
      engine = "cometbft/cometbft";

      preFixup = ''
        ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "strided"}
      '';
      buildInputs = [libwasmvm_1_5_2];

      patches = [../patches/stride-no-admin-check.patch];
      doCheck = false;
    };
  }
