{ packages, inputs, pkgs, system }:
let
  nixosTests = {
    hermes-module = (import ./modules/relayer/hermes-test.nix) {
      inherit (packages) hermes;
      inherit system pkgs;
    };
  };
in
{
  pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
    src = ./.;
    hooks = {
      nixpkgs-fmt.enable = true;
      nix-linter.enable = true;
    };
  };
} // packages # adding packages here ensures that every attr gets built on check
  // (if pkgs.lib.strings.hasSuffix "darwin" system then { } else nixosTests)
