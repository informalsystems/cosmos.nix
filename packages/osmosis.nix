{
  cosmosLib,
  osmosis-src,
  libwasmvm_2_1_3,
  libiconv,
}:
cosmosLib.mkCosmosGoApp {
  name = "osmosis";
  version = "v27.0.1";
  # nixpkgs latest go version v1.22 is v1.22.5 but Osmosis v27.0.1 requires
  # v1.22.7 or more so v1.23 is used instead
  goVersion = "1.23";
  src = osmosis-src;
  rev = osmosis-src.rev;
  vendorHash = "sha256-wiEixpZPbnwMdhyNrQvHz3cLZF/GXJRa7ho0YaAnVuc=";
  tags = ["netgo"];
  excludedPackages = ["cl-genesis-positions"];
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_1_3 "osmosisd"}
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_1_3 "chain"}
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_1_3 "node"}
  '';
  buildInputs = [libwasmvm_2_1_3 libiconv];
  proxyVendor = true;

  # Test has to be skipped as end-to-end testing requires network access
  doCheck = false;

  meta = {
    mainProgram = "osmosisd";
  };
}
