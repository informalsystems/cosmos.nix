{ pkgs, iris-src }:
pkgs.buildGoApplication {
  name = "iris";
  src = "${iris-src}";
  modules = ./go-modules.toml;
}

