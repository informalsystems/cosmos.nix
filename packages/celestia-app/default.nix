{
  mkGenerator,
  celestia-app-src,
  pkgs,
}: {
  # NOTE: this uses `buildGoApplication` from `gomod2nix`. Which requires that you pre-generate
  # the go.mod dependency hashes. Therefore you need to run `nix run .#gen-celestia-app` which is below
  celestia-app = pkgs.buildGoApplication {
    name = "celestia-app";
    version = "v2.1.2";
    src = celestia-app-src;
    go = pkgs.go_1_23;
    pwd = ./.;
    modules = ./gomod2nix.toml;
    doCheck = false;
  };
  gen-celestia-app = mkGenerator "gen-celestia" celestia-app-src;
}
