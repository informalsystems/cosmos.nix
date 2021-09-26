{ pkgs, ethermint-src }:
pkgs.buildGoApplication {
  name = "ethermint";
  src = "${ethermint-src}";
  modules = ./go-modules.toml;
  # doCheck = false;
  # NOTE: we need to create a tmp home directory for gaia's tests
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
  CGO_ENABLED = "1";
}

