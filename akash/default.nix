{ pkgs, akash-src }:
pkgs.buildGoApplication {
  name = "akash";
  src = "${akash-src}";
  modules = ./go-modules.toml;
}

