{
  cosmosLib,
  mantrachain-src,
  libwasmvm_2_1_3,
}:
cosmosLib.mkCosmosGoApp {
  name = "mantrachain";
  vendorHash = "sha256-F+VZlwhxaV0ZyZ56AgEOIdEBerTFwqlfr0C2jDPxVnk=";
  version = "v1.0.3";
  goVersion = "1.23";
  src = mantrachain-src;
  rev = mantrachain-src.rev;
  tags = [ "netgo" "pebbledb" ];
  engine = "cometbft/cometbft";

  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_1_3 "mantrachaind"}
  '';
  buildInputs = [ libwasmvm_2_1_3 ];

  # Tests have to be disabled because they require Docker to run
  doCheck = false;

  excludedPackages = [ "tests/connect" "scripts/ci-goreleaser" ];

  meta = {
    mainProgram = "mantrachaind";
  };
}