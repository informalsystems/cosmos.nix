{
  neutron-src,
  cosmosLib,
  libwasmvm_1_2_3,
}:
cosmosLib.mkCosmosGoApp {
  name = "neutron";
  version = "v1.0.2";
  src = neutron-src;
  vendorSha256 = "sha256-Q3QEk7qS1ue/HrvwdkGh6iX8BTg+0ssznyWsYtzZ+/4=";
  engine = "tendermint/tendermint";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_2_3 "neutrond"}
  '';
  buildInputs = [libwasmvm_1_2_3];
}
