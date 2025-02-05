{
  inputs,
  mkCosmosGoApp,
  cosmosLib,
  libwasmvm_1_5_4,
}:
with inputs;
  builtins.mapAttrs (_: mkCosmosGoApp)
  {
    stride = {
      name = "stride";
      version = "v24.0.0";
      goVersion = "1.21";
      src = stride-src;
      rev = stride-src.rev;
      vendorHash = "sha256-Tg96wuqgS08GGorY5Hbq3eJvJ7ZngI7XCqOIw84isSI=";
      engine = "cometbft/cometbft";

      preFixup = ''
        ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_4 "strided"}
      '';
      buildInputs = [libwasmvm_1_5_4];

      doCheck = false;
    };

    stride-no-admin = {
      name = "stride-no-admin";
      version = "v24.0.0";
      goVersion = "1.21";
      src = stride-src;
      rev = stride-src.rev;
      vendorHash = "sha256-Tg96wuqgS08GGorY5Hbq3eJvJ7ZngI7XCqOIw84isSI=";
      engine = "cometbft/cometbft";

      preFixup = ''
        ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_4 "strided"}
      '';
      buildInputs = [libwasmvm_1_5_4];

      patches = [../patches/stride-no-admin-check.patch];
      doCheck = false;
    };
  }
