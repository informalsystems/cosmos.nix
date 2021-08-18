{ pkgs, gaia5-src }:
pkgs.buildGoApplication {
  name = "gaia5";
  src = "${gaia5-src}";
  modules = ./go-modules.toml;

  # NOTE: we need to create a tmp home directory for gaia's tests
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
}

