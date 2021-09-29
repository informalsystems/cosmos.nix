{ packages, inputs, pkgs, system }:
let
  go-source-inputs = (import ./sync-go-modules/go-source-inputs.nix) { inherit inputs; };
  go-modules-check = (import ./sync-go-modules) { inherit pkgs go-source-inputs; };
in
{
  pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
    src = ./.;
    hooks = {
      nixpkgs-fmt.enable = true;
      nix-linter.enable = true;
      sync-go-modules = {
        enable = true;
        name = "go-modules-check";
        entry = "${go-modules-check} -l";
        files = "(\\.(lock|narHash)|flake.nix)$";
        language = "system";
        pass_filenames = false;
      };
    };
  };
} // packages # adding packages here ensures that every attr gets built on check

