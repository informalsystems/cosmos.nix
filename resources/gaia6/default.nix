{ pkgs, gaia6-src }:
pkgs.buildGoApplication {
  pname = "gaia";
  version = "v6.0.0-rc3";
  src = "${gaia6-src}";
  modules = ./go-modules.toml;
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
}

