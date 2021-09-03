{ pkgs, sconfig-src }:
pkgs.buildGoApplication {
  name = "sconfig";
  src = "${sconfig-src}";
  modules = ./go-modules.toml;

  # The tests for cosmovisor require a network connection
  # and nix doesn't allow this, so we have to disable checks.
  # doCheck = false;
}

