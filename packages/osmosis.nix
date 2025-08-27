{
  cosmosLib,
  osmosis-src,
  libwasmvm_2_2_4,
  libiconv,
}:
cosmosLib.mkCosmosGoApp {
  name = "osmosis";
  version = "v30.0.1";
  # nixpkgs latest go version v1.22 is v1.22.5 but Osmosis v28.0.8 requires
  # v1.22.7 or more so v1.23 is used instead
  goVersion = "1.23";
  src = osmosis-src;
  rev = osmosis-src.rev;
  vendorHash = "sha256-jXfYYZUjm7QU6rCy/zQPUkb3BfgZ1/VA/gUL+n8Cb20=";
  tags = ["netgo"];
  excludedPackages = ["cl-genesis-positions"];
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_2_4 "osmosisd"}
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_2_4 "chain"}
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_2_4 "node"}
  '';
  buildInputs = [libwasmvm_2_2_4 libiconv];
  proxyVendor = true;

  # Test has to be skipped as end-to-end testing requires network access
  doCheck = false;

  meta = {
    mainProgram = "osmosisd";
  };
}
