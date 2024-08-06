{
  neutron-src,
  cosmosLib,
  libwasmvm_2_0_0,
}:
cosmosLib.mkCosmosGoApp {
  goVersion = "1.22";
  name = "neutron";
  version = "v4.1.0";
  src = neutron-src;
  rev = neutron-src.rev;
  vendorHash = "sha256-SKuAOWosHM2tvVAsTu54sAfbiTtCoJap3/LA4zfmuOo=";
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_0_0 "neutrond"}
  '';
  buildInputs = [libwasmvm_2_0_0];

  # main module (github.com/neutron-org/neutron/v4) does not contain package github.com/neutron-org/neutron/v4/tests/feemarket
  # main module (github.com/neutron-org/neutron/v4) does not contain package github.com/neutron-org/neutron/v4/tests/slinky
  excludedPackages = ["tests/feemarket" "tests/slinky"];
}
