{ pkgs, gaia-src }:
pkgs.buildGoApplication {
  name = "gaia";
  src = "${gaia-src}";
  modules = ./go-modules.toml;
}

