{ pkgs, gaia-src }:
pkgs.buildGoApplication {
  name = "gaia";
  src = "${gaia-src}";
  modules = ./go-modules.toml;

  # NOTE: we need to disable the check phase since the tests use $HOME which
  # is not allowed in nix's hermetic environment.
  # N.B. $HOME = /homeless-shelter with no write permissions
  doCheck = false;
}

