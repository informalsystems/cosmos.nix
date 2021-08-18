{ pkgs, gaia4-src }:
pkgs.buildGoApplication {
  name = "gaia4";
  src = "${gaia4-src}";
  modules = ./go-modules.toml;

  # NOTE: we need to create a tmp home directory for gaia's tests
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
}

