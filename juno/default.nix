{ pkgs, juno-src }:
pkgs.buildGoApplication {
  name = "juno";
  src = "${juno-src}";
  modules = ./go-modules.toml;
}
