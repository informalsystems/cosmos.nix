{ pkgs, osmosis-src }:
pkgs.buildGoApplication {
  name = "osmosis";
  src = "${osmosis-src}";
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
  modules = ./go-modules.toml;
}

