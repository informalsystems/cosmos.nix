{ pkgs, cosmovisor-src }:
pkgs.buildGoApplication {
  name = "cosmovisor";
  src = "${cosmovisor-src}";
  modules = ./go-modules.toml;

  doCheck = false;
}

