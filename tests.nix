{
  packages,
  pkgs,
  system,
}:
if pkgs.lib.strings.hasSuffix "darwin" system
then {}
else {
  hermes-module-test = (import ./modules/tests/hermes-test.nix) {
    inherit (packages) hermes;
    inherit pkgs;
    gaia = packages.gaia7;
  };
  gaia-module-test = (import ./modules/tests/gaia-test.nix) {
    inherit pkgs;
    gaia = packages.gaia7;
  };
}
