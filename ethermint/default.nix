{ pkgs, ethermint-src }:
pkgs.buildGoApplication {
  name = "ethermint";
  src = "${ethermint-src}";
  modules = ./go-modules.toml;
  doCheck = false;
  CGO_ENABLED = "1";
}

