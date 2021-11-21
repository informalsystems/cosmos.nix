{ pkgs, ethermint-src }:
pkgs.buildGoApplication {
  name = "ethermint";
  src = "${ethermint-src}";
  modules = ./go-modules.toml;
  # NOTE: we need to create a tmp home directory for gaia's tests
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
  CGO_ENABLED = "1";
}

