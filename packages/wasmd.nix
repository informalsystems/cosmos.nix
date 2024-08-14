{
  wasmd-src,
  cosmosLib,
  libwasmvm_2_1_0,
}:
cosmosLib.mkCosmosGoApp {
  name = "wasm";
  version = "v0.52.0";
  goVersion = "1.21";
  src = wasmd-src;
  rev = wasmd-src.rev;
  vendorHash = "sha256-G4SujfIKNlfGUr7mM9C/iXd0Xc0/wEl6tJB02TufeiI=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  preFixup = cosmosLib.wasmdPreFixupPhase libwasmvm_2_1_0 "wasmd";
  dontStrip = true;
  buildInputs = [libwasmvm_2_1_0];

  # main module (github.com/CosmWasm/wasmd) does not contain package github.com/CosmWasm/wasmd/tests/system
  excludedPackages = ["tests/system"];

  doCheck = false;
}
