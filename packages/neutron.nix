{
  neutron-src,
  cosmosLib,
  libwasmvm_1_5_2,
}:
cosmosLib.mkCosmosGoApp {
  goVersion = "1.21";
  name = "neutron";
  version = "v3.0.5";
  src = neutron-src;
  rev = neutron-src.rev;
  vendorHash = "sha256-6WV7Z0KbvDReCJ7JccPnRWPkR4BMrfxRouTC5cC6PZc=";
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "neutrond"}
  '';
  buildInputs = [libwasmvm_1_5_2];
}
