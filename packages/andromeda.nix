{
  andromeda-src,
  cosmosLib,
  libwasmvm_1_3_0,
}:
cosmosLib.mkCosmosGoApp {
  name = "andromeda";
  version = "andromeda-1";
  src = andromeda-src;
  rev = andromeda-src.rev;
  vendorHash = "sha256-TVKZp6K8M4yTuSoVu60ovu1SFVonrkKnw/6dthbuzAw=";
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_3_0 "andromedad"}
  '';
  buildInputs = [libwasmvm_1_3_0];
}
