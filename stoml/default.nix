{ pkgs, stoml-src }:
pkgs.buildGoApplication {
  name = "stoml";
  src = "${stoml-src}";
  modules = ./go-modules.toml;
}
