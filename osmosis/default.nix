{ pkgs, osmosis-src }:
pkgs.buildGoApplication {
  name = "osmosis";
  src = "${osmosis-src}";
  modules = ./go-modules.toml;
}

