{ pkgs, cosmos-sdk-src }:
pkgs.buildGoApplication {
  name = "cosmos-sdk";
  src = "${cosmos-sdk-src}";
  postConfigure = ''
    rm -rf ./cosmovisor
  '';
  modules = ./go-modules.toml;
  doCheck = false;
}

