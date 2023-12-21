{
  mkGenerator,
  evmos-src,
  pkgs,
}: {
  # NOTE: this uses `buildGoApplication` from `gomod2nix`. Which requires that you pre-generate
  # the go.mod dependency hashes. Therefore you need to run `nix run .#gen-evmos` which is below
  evmos = pkgs.buildGoApplication {
    pname = "evmos";
    version = "v16.0.0-rc4";
    src = evmos-src;
    goVersion = "1.21";
    modules = ./gomod2nix.toml;
    doCheck = false;
  };
  gen-evmos = mkGenerator "gen-evmos" evmos-src;
}
