{
  neutron-src,
  cosmosLib,
  libwasmvm_1_5_0,
}:
cosmosLib.mkCosmosGoApp {
  goVersion = "1.20";
  name = "neutron";
  version = "v1.2.0";
  src = neutron-src;
  vendorHash = "sha256-uLInKbuL886cfXCyQvIDZJHUC8AK9fR39yNBHDO+Qzc=";
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_0 "neutrond"}
  '';
  buildInputs = [libwasmvm_1_5_0];
}
