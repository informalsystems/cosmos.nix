{
  injective-src,
  cosmosLib,
  libwasmvm_1_5_0,
}:
cosmosLib.mkCosmosGoApp {
  name = "injective";
  version = "v1.12.1";
  src = injective-src;
  rev = injective-src.rev;
  vendorHash = "sha256-2Cz9B+NFm1sXIgmnCBJbYCb8J8JJf1aGZbUL90eFzo0=";
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_0 "injectived"}
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_0 "client"}
  '';
  buildInputs = [libwasmvm_1_5_0];
}
