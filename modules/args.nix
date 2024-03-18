# This module sets the 'pkgs' argument that is passed to all 'perSystem' definitions
# it can also set any additional args that we might require.
#
# docs on re-defining pkgs:
#   - https://flake.parts/module-arguments#pkgs
#   - https://flake.parts/overlays.html#consuming-an-overlay
{inputs, ...}: {
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [
        inputs.rust-overlay.overlays.default
        inputs.sbt-derivation.overlays.default
        (prev: final: {
          inherit (inputs.gomod2nix.legacyPackages.${system}) buildGoApplication gomod2nix;
          inherit (inputs.nix2container.packages.${system}) nix2container;
        })
      ];
      config = {};
    };
  };
}
