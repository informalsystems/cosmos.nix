{ pkgs, gaia4-src }:
pkgs.buildGoApplication {
  pname = "gaia";
  version = "4.2.1";
  src = "${gaia4-src}";
  modules = ./go-modules.toml;

  # NOTE: we need to create a tmp home directory for gaia's tests
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
}

