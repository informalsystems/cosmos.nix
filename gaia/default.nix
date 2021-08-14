{ pkgs, gaia-src }:
pkgs.buildGoApplication {
  name = "gaia";
  src = "${gaia-src}";
  modules = ./go-modules.toml;

  # NOTE: we need to create a tmp home directory for gaia's tests
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
}

