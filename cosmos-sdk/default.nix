{ pkgs, cosmos-sdk-src }:
pkgs.buildGoApplication {
  name = "cosmos-sdk";
  src = "${cosmos-sdk-src}";
  modules = ./go-modules.toml;
  doCheck = false;
}

