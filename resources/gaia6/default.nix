{ pkgs, gaia6-src }:
pkgs.buildGoApplication {
  pname = "gaia";
  version = "v6.0.0-rc2";
  src = "${gaia6-src}";
  modules = ./go-modules.toml;

  # NOTE: we need to create a tmp home directory for gaia's tests
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
}

