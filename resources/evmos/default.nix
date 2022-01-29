{ pkgs, evmos-src }:
pkgs.buildGoApplication {
  name = "evmos";
  src = "${evmos-src}";
  modules = ./go-modules.toml;
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
  CGO_ENABLED = "1";
}

