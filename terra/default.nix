{ pkgs, terra-src }:
pkgs.buildGoApplication {
  name = "terra";
  src = "${terra-src}";
  modules = ./go-modules.toml;
  CGO_ENABLED = "1";
  doCheck = false;
}

