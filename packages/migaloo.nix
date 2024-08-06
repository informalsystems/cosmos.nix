{
  migaloo-src,
  cosmosLib,
  libwasmvm_1_5_2,
}:
cosmosLib.mkCosmosGoApp {
  name = "migaloo";
  version = "v4.2.0";
  goVersion = "1.22";
  src = migaloo-src;
  rev = migaloo-src.rev;
  vendorHash = "sha256-ZmQk9o9tqysfz65Lr9bjT0DwZhVTNMmvO8j13sMXGk8=";
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_2 "migalood"}
  '';
  buildInputs = [libwasmvm_1_5_2];
}
