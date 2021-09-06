{ pkgs, terra-src }:
pkgs.buildGoApplication {
  name = "terra";
  src = "${terra-src}";
  modules = ./go-modules.toml;
}

