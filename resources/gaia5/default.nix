{ pkgs, gaia5-src }:
pkgs.buildGoApplication {
  pname = "gaia";
  version = "5.0.6";
  src = "${gaia5-src}";
  modules = ./go-modules.toml;
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
}

