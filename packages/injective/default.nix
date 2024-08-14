{
  pkgs,
  injective-src,
  system,
  cosmosLib,
  libwasmvm_2_0_0,
  mkGenerator,
}: {
  injective = pkgs.gomod2nix.buildGoApplication {
    # NOTE: this uses `buildGoApplication` from `gomod2nix`. Which requires that you pre-generate
    # the go.mod dependency hashes. Therefore you need to run `nix run .#gen-injective` which is below
    pname = "injective";
    version = "v1.13.1";
    src = injective-src;
    go = pkgs.go_1_22;
    modules = ./gomod2nix.toml;
    doCheck = false;
    pwd = ./.;

    engine = "cometbft/cometbft";
    preFixup = ''
      ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_0_0 "injectived"}
      ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_0_0 "client"}
    '';
    buildInputs = [libwasmvm_2_0_0];
  };
  gen-injective = mkGenerator "gen-injective" injective-src;
}
