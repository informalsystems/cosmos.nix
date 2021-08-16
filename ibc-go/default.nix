{ pkgs, ibc-go-src }:
pkgs.buildGoApplication {
  name = "ibc-go";
  src = "${ibc-go-src}";
  modules = ./go-modules.toml;
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
}

