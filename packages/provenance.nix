{
  cosmosLib,
  provenance-src,
  libwasmvm_2_1_0,
}:
cosmosLib.mkCosmosGoApp {
  name = "provenance";
  version = "v1.19.1";
  src = provenance-src;
  rev = provenance-src.rev;
  vendorHash = "sha256-RTGQuDVxK4U+o+P8YJIkQJnjNEfRdFqoDHxXuPpndE8=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_1_0 "provenanced"}
  '';
  # dbmigrate is problematic as it depends implicitly on the build/ directory being present at runtime,
  # which is not guaranteed to be there.
  #
  # When nix is stripping build dependencies from the binary's rpath and detects
  # a runtime dependency whose path don't exist in the nix store it is kind enough to warn us that this will
  # cause problems.
  #
  # relevant error:
  #
  # shrinking RPATHs of ELF executables and libraries in /nix/store/ixa51frqnjz50k63fiiwx72b2fmg5mjj-provenance-v1.17.0
  # > shrinking /nix/store/ixa51frqnjz50k63fiiwx72b2fmg5mjj-provenance-v1.17.0/bin/dbmigrate
  # > shrinking /nix/store/ixa51frqnjz50k63fiiwx72b2fmg5mjj-provenance-v1.17.0/bin/provenanced
  # > checking for references to /build/ in /nix/store/ixa51frqnjz50k63fiiwx72b2fmg5mjj-provenance-v1.17.0...
  # > RPATH of binary /nix/store/ixa51frqnjz50k63fiiwx72b2fmg5mjj-provenance-v1.17.0/bin/dbmigrate contains a forbidden reference to /build/
  excludedPackages = [
    "./cmd/dbmigrate"
  ];
  buildInputs = [libwasmvm_2_1_0];
}
