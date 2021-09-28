{ pkgs, gravity-dex-src }:
pkgs.buildGoApplication {
  name = "gravity-dex";
  src = "${gravity-dex-src}";
  modules = ./go-modules.toml;
  doCheck = false;
}

