{
  neutron-src,
  cosmosLib,
  libwasmvm_1_5_2,
}:
cosmosLib.mkCosmosGoApp {
  goVersion = "1.21";
  name = "neutron";
  version = "v3.0.2";
  src = neutron-src;
  rev = neutron-src.rev;
  vendorHash = "sha256-Ao/soQsOw00QZ8c7BF42od303wdiFo30flWSPTm5Mzc=";
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "neutrond"}
  '';
  buildInputs = [libwasmvm_1_5_2];
}
