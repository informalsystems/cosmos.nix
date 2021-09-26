{ pkgs, sentinel-src }:
pkgs.buildGoApplication {
  name = "sentinel";
  src = "${sentinel-src}";
  modules = ./go-modules.toml;
}

