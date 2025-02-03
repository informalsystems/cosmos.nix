{
  cosmosLib,
  osmosis-src,
  libwasmvm_2_1_3,
  libiconv,
}:
cosmosLib.mkCosmosGoApp {
  name = "osmosis";
  version = "v28.0.0";
  # nixpkgs latest go version v1.22 is v1.22.5 but Osmosis v28.0.8 requires
  # v1.22.7 or more so v1.23 is used instead
  goVersion = "1.23";
  src = osmosis-src;
  rev = osmosis-src.rev;
  vendorHash = "sha256-hkF1TO1E1vKLC380dhaaDQAU+t8t4SxhP1UOV41KdUc=";
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
