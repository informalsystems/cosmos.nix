{
  cosmosLib,
  provenance-src,
  libwasmvm_1_2_4,
}:
cosmosLib.mkCosmosGoApp {
  name = "provenance";
  version = "v1.17.0";
  goVersion = "1.20";
  src = provenance-src;
  vendorSha256 = "sha256-XFU/+lMwg4hLlyYGUvDp0SqGqijrUQZddoH4VkIvqHg=";
  tags = ["netgo"];
  engine = "tendermint/tendermint";
  preFixup = ''
    ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_2_4 "provenanced"}
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
  buildInputs = [libwasmvm_1_2_4];
}
