{ pkgs, sconfig-src }:
pkgs.buildGoApplication {
  name = "sconfig";
  src = "${sconfig-src}";
  modules = ./go-modules.toml;
}

