{ pkgs, gaia4-src }:
pkgs.buildGoApplication {
  pname = "gaia";
  version = "4.2.1";
  src = "${gaia4-src}";
  modules = ./go-modules.toml;
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
}

