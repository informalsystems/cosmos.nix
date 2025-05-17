{
  cosmosLib,
  mantrachain-src,
  libwasmvm_2_2_1,
}:
cosmosLib.mkCosmosGoApp {
  name = "mantrachain";
  vendorHash = "sha256-2NabeyqOjm5Ftec/WNzVVuBiluRVmKvDADNRDnv5aG4=";
  version = "v2.0.0";
  goVersion = "1.23";
  src = mantrachain-src;
  rev = mantrachain-src.rev;
  tags = [ "netgo" "pebbledb" ];
  engine = "cometbft/cometbft";

  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_2_1 "mantrachaind"}
  '';
  buildInputs = [ libwasmvm_2_2_1 ];

  # Tests have to be disabled because they require Docker to run
  doCheck = false;

  excludedPackages = [ "tests/connect" "tests/interchain" "scripts/ci-goreleaser" ];

  meta = {
    mainProgram = "mantrachaind";
  };
}