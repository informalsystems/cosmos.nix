{ pkgs, relayer-src }:
pkgs.buildGoApplication {
  name = "relayer";
  src = "${relayer-src}";
  modules = ./go-modules.toml;
  doCheck = false;
}
