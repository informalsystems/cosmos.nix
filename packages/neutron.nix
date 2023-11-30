{
  neutron-src,
  cosmosLib,
  libwasmvm_1_2_3,
}:
cosmosLib.mkCosmosGoApp {
  name = "neutron";
  version = "v1.0.4";
  src = neutron-src;
  vendorHash = "sha256-jlzFYx09U7BkBg9LDZqfwT4aASQSbuVBl0a/WCrly8A=";
  engine = "tendermint/tendermint";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_2_3 "neutrond"}
  '';
  buildInputs = [libwasmvm_1_2_3];
}
