{ pkgs, thor-src }:
pkgs.buildGoApplication {
  name = "thor";
  src = "${thor-src}";
  modules = ./go-modules.toml;
  preBuild = ''
  '';
  doCheck = false;
}

