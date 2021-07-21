{
  description = "Rust implementation of the Inter-Blockchain Communication (IBC) protocol.";

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
    ibc-rs-src = {
      url = github:informalsystems/ibc-rs;
      flake = false;
    };

  };

  outputs =
    { nixpkgs
    , rust-overlay
    , crate2nix
    , flake-utils
    , ibc-rs-src
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
      packages = utils.flattenTree
        {
          hermes =
            let
              name = "ibc-rs";
              # The use of `evalPkgs` here is a major hack. This is to get around the IFD limitation in nix flakes
              # See this github issue: https://github.com/NixOS/nix/issues/4265#issuecomment-732358327
              generateCargoNix = (import "${crate2nix}/tools.nix" { pkgs = evalPkgs; }).generatedCargoNix;

              # Create the cargo2nix project
              cargoNix = pkgs.callPackage
                (generateCargoNix {
                  inherit name;
                  src = ibc-rs-src;
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
            cargoNix.workspaceMembers.ibc-relayer-cli.build;
        };

      # nix build
      defaultPackage = packages.hermes;

      # nix run
      apps = {
        hermes = {
          type = "app";
          program = "${packages.hermes}/bin/hermes";
        };
      };
      defaultApp = apps.hermes;
    });
}
