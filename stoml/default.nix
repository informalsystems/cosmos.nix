{ pkgs, stoml-src }:
pkgs.buildGoApplication {
  name = "stoml";
  src = "${stoml-src}";
  modules = ./go-modules.toml;

  # The tests for cosmovisor require a network connection
  # and nix doesn't allow this, so we have to disable checks.
  # doCheck = false;
}

