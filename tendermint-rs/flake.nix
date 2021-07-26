{
  description = "Tendermint in Rust with TLA+ specifications.";

  inputs = {
    # Nix Inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Rust Inputs
    rust-overlay.url = "github:oxalica/rust-overlay";
    crate2nix = {
      url = "github:yusdacra/crate2nix/feat/builtinfetchgit";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";

    # Cosmos Sources
    tendermint-rs-src = {
      flake = false;
      # url = github:informalsystems/tendermint-rs;
      url = "path:../../../tendermint-rs";
    };

  };

  outputs =
    { nixpkgs
    , rust-overlay
    , crate2nix
    , flake-utils
    , tendermint-rs-src
    , ...
    }:
    let utils = flake-utils.lib; in
    utils.eachDefaultSystem (system:
    let
      overlays = [
        rust-overlay.overlay
        (final: _: {
          # Because rust-overlay bundles multiple rust packages into one
          # derivation, specify that mega-bundle here, so that crate2nix
          # will use them automatically.
          rustc = final.rust-bin.stable.latest.default;
          cargo = final.rust-bin.stable.latest.default;
        })
      ];
      pkgs = import nixpkgs { inherit system overlays; };
      evalPkgs = import nixpkgs { system = "x86_64-linux"; inherit overlays; };
    in
    rec {
      packages =
        let
          name = "tendermint-rs";
          # The use of `evalPkgs` here is a major hack. This is to get around the IFD limitation in nix flakes
          # See this github issue: https://github.com/NixOS/nix/issues/4265#issuecomment-732358327
          generateCargoNix = (import "${crate2nix}/tools.nix" { pkgs = evalPkgs; }).generatedCargoNix;

          # Create the cargo2nix project
          cargoNix = pkgs.callPackage
            (generateCargoNix {
              inherit name;
              src = tendermint-rs-src;
              additionalCargoNixArgs = [ "--all-features" ];
            })
            {
              # Individual crate overrides
              defaultCrateOverrides = pkgs.defaultCrateOverrides // {
                ${name} = _: {
                  nativeBuildInputs = with pkgs; [ rustc cargo pkgconfig ];
                  buildInputs = with pkgs; [ openssl ];
                };
                openssl-sys = _: {
                  nativeBuildInputs = with pkgs; [ rustc cargo pkgconfig ];
                  buildInputs = with pkgs; [ openssl ];
                };
              };
            };
        in
        utils.flattenTree {
          # tendermint = cargoNix.workspaceMembers.tendermint.build.override {
          #   features = [ "secp256k1" ];
          # };
          tendermint-rpc = cargoNix.workspaceMembers.tendermint-rpc.build.override {
            features = [
              "default"
              "cli"
              "http-client"
              "websocket-client"
            ];
          };
          tendermint-light-client = cargoNix.workspaceMembers.tendermint-light-client.build.override {
            features = [
              "default"
              "rpc-client"
              "lightstore-sled"
              "unstable"
              "cli"
              "http-client"
              "websocket-client"
            ];
          };
          tendermint = cargoNix.workspaceMembers.tendermint.build;
          # tendermint-rpc = cargoNix.workspaceMembers.tendermint-rpc.build;
          # tendermint-light-client = cargoNix.workspaceMembers.tendermint-light-client.build;
        };

      # nix build
      defaultPackage = packages.tendermint-light-client;

      # nix run
      apps = {
        tendermint-light-client = utils.mkApp { drv = packages.tendermint-light-client; };
      };
      defaultApp = apps.tendermint-light-client;
    });
}
