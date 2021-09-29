{ system
, inputs
, pkgs
, eval-pkgs
}:
with inputs;
let
  # Cosmos packages
  packages = {
    stoml = (import ./stoml) { inherit pkgs stoml-src; };
    sconfig = (import ./sconfig) { inherit pkgs sconfig-src; };
    gm = (import ./gm) { inherit pkgs ibc-rs-src; };
    hermes = naersk.lib."${system}".buildPackage {
      pname = "ibc-rs";
      root = ibc-rs-src;
      buildInputs = with pkgs; [ rustc cargo pkgconfig ];
      nativeBuildInputs = with pkgs; [ openssl ];
    };
    cosmovisor = (import ./cosmovisor) {
      inherit pkgs;
      cosmovisor-src = "${cosmos-sdk-src}/cosmovisor";
    };
    cosmos-sdk = (import ./cosmos-sdk) { inherit pkgs cosmos-sdk-src; };
    gaia6 = (import ./gaia6) { inherit gaia6-src pkgs; };
    gaia5 = (import ./gaia5) { inherit gaia5-src pkgs; };
    gaia4 = (import ./gaia4) { inherit gaia4-src pkgs; };
    thor = (import ./thor) { inherit pkgs thor-src; };
    osmosis = (import ./osmosis) { inherit pkgs osmosis-src; };
    gravity-dex = (import ./gravity-dex) { inherit pkgs gravity-dex-src; };
    iris = (import ./iris) { inherit iris-src pkgs; };
    regen = (import ./regen) { inherit regen-src pkgs; };
    ethermint = (import ./ethermint) { inherit ethermint-src pkgs; };
    juno = (import ./juno) { inherit juno-src pkgs; };
    ts-relayer = ((import ./ts-relayer) { inherit ts-relayer-src pkgs eval-pkgs; }).ts-relayer;
    ts-relayer-setup = ((import ./ts-relayer) { inherit ts-relayer-src pkgs eval-pkgs; }).ts-relayer-setup;

  };

  # Script helpers
  go-source-inputs = (import ./go-source-inputs.nix) { inherit inputs; };
  go-modules-sync = pkgs.writeShellScriptBin "syncGoModules" ''
    echo "${go-source-inputs}" | ./sync-go-modules/sync.hs
  '';

  # Dev shells
  devShells = {
    nix-shell =
      pkgs.mkShell {
        shellHook = self.checks.${system}.pre-commit-check.shellHook;
        buildInputs = [
          pkgs.gomod2nix
          go-modules-sync
        ];
      };
    cosmos-shell =
      pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          go
          rustc
          cargo
          pkg-config
        ];
        buildInputs = with pkgs; [
          openssl
          shellcheck
        ] ++ builtins.attrValues packages;
      };
  };
in
{ inherit packages devShells; }
