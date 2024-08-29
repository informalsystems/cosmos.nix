{
  neutron-src,
  cosmosLib,
  libwasmvm_2_0_3,
}:
cosmosLib.mkCosmosGoApp {
  # nixpkgs latest go version v1.22 is v1.22.5 but Neutron v4.2.2 requires
  # v1.22.6 or more so v1.23 is used instead
  goVersion = "1.23";
  name = "neutron";
  version = "v4.2.2";
  src = neutron-src;
  rev = neutron-src.rev;
  vendorHash = "sha256-5yjri/9QCSnHieWu/v9AYcktP+kXFEyWE7IbhkoNFXs=";
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_0_3 "neutrond"}
  '';
  buildInputs = [libwasmvm_2_0_3];

  # main module (github.com/neutron-org/neutron/v4) does not contain package github.com/neutron-org/neutron/v4/tests/feemarket
  # main module (github.com/neutron-org/neutron/v4) does not contain package github.com/neutron-org/neutron/v4/tests/slinky
  excludedPackages = ["tests/feemarket" "tests/slinky"];
}
