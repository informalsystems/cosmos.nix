{ pkgs, ethermint-src }:
pkgs.buildGoApplication {
  name = "ethermint";
  src = "${ethermint-src}";
  modules = ./go-modules.toml;
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
  CGO_ENABLED = "1";
}

