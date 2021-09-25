{ pkgs, regen-src }:
pkgs.buildGoApplication {
  name = "regen";
  src = "${regen-src}";
  modules = ./go-modules.toml;
}
