{
  description = "A reproducible Cosmos";

  inputs = {
    # Nix Inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    flake-utils.url = "github:numtide/flake-utils";

    # Rust Inputs
    rust-overlay.url = "github:oxalica/rust-overlay";
    # crate2nix = {
    #   url = "github:yusdacra/crate2nix/feat/builtinfetchgit";
    #   flake = false;
    # };
    naersk.url = "github:nmattia/naersk";

    # Go Inputs
    gomod2nix.url = "github:tweag/gomod2nix";

    # Freshautomations inputs
    stoml-src = {
      url = github:freshautomations/stoml;
      flake = false;
    };

    sconfig-src = {
      url = github:freshautomations/sconfig;
      flake = false;
    };

    # Cosmos Sources
    ibc-rs-src = {
      url = github:informalsystems/ibc-rs;
      flake = false;
    };

    gaia-src = {
      flake = false;
      url = github:cosmos/gaia;
    };

    cosmos-sdk-src = {
      flake = false;
      url = github:cosmos/cosmos-sdk;
    };
  };

  outputs =
    { self
    , nixpkgs
    , pre-commit-hooks
    , flake-utils
    , rust-overlay
    , naersk
    , gomod2nix
    , stoml-src
    , sconfig-src
    , ibc-rs-src
    , gaia-src
    , cosmos-sdk-src
    }:
    let
      overlays = [
        rust-overlay.overlay
        (final: _: {
          # Because rust-overlay bundles multiple rust packages into one
          # derivation, specify that mega-bundle here, so that crate2nix
          # will use them automatically.
          rustc = final.rust-bin.nightly.latest.default;
          cargo = final.rust-bin.nightly.latest.default;
        })
        gomod2nix.overlay
      ];
    in
    with flake-utils.lib;
    eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system overlays; };
      naersk-lib = naersk.lib."${system}".override {
        cargo = pkgs.cargo;
        rustc = pkgs.rustc;
      };
      goProjectSrcs = {
        stoml = {
          inputName = "stoml-src";
          storePath = "${stoml-src}";
        };
        sconfig = {
          inputName = "sconfig-src";
          storePath = "${sconfig-src}";
        };
        gaia = {
          inputName = "gaia-src";
          storePath = "${gaia-src}";
        };
        cosmovisor = {
          inputName = "cosmos-sdk-src";
          storePath = "${cosmos-sdk-src}/cosmovisor";
        };
      };
      syncGoModulesInputs = with builtins; concatStringsSep " "
        (attrValues (builtins.mapAttrs (name: value: "${name}:${value.inputName}${value.storePath}") goProjectSrcs));
      syncGoModulesCheck = (import ./syncGoModules) { inherit pkgs syncGoModulesInputs; };
    in
    rec {
      # nix build .#<app>
      packages = flattenTree
        {
          stoml = (import ./stoml) { inherit pkgs stoml-src; };
          sconfig = (import ./sconfig) { inherit pkgs sconfig-src; };
          gm = (import ./gm) { inherit pkgs ibc-rs-src; };
          hermes = naersk-lib.buildPackage {
            pname = "ibc-rs";
            root = ibc-rs-src;
            buildInputs = with pkgs; [ rustc cargo pkgconfig ];
            nativeBuildInputs = with pkgs; [ openssl ];
          };
          gaia = (import ./gaia) { inherit gaia-src pkgs; };
          cosmovisor = (import ./cosmovisor) { inherit pkgs; cosmovisor-src = goProjectSrcs.cosmovisor.storePath; };
        };

      # nix flake check
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            nix-linter.enable = true;
            sync-go-modules = with builtins;
              {
                enable = true;
                name = "sync-go-modules";
                entry = "${syncGoModulesCheck}/bin/syncGoModulesCheck -l";
                files = "(\\.(lock|narHash)|flake.nix)$";
                language = "system";
                pass_filenames = false;
              };
          };
        };
      };

      # nix develop
      devShell =
        let
          syncGoModulesInputs = with builtins; concatStringsSep " "
            (attrValues (builtins.mapAttrs (name: value: "${name}:${value.inputName}${value.storePath}") goProjectSrcs));
          syncGoModulesScript = pkgs.writeShellScriptBin "syncGoModules" ''
            echo "${syncGoModulesInputs}" | ./syncGoModules/syncGoModules.hs
          '';
        in
        pkgs.mkShell {
          shellHook = self.checks.${system}.pre-commit-check.shellHook;
          nativeBuildInputs = with pkgs; [
            rustc
            cargo
            pkg-config
          ];
          buildInputs = with pkgs; [
            # need to prefix with pkgs because of they shadow the name of inputs
            pkgs.crate2nix
            pkgs.gomod2nix

            openssl
            syncGoModulesScript

            # gaia manager dependencies
            packages.stoml
            packages.sconfig
            pkgs.gnused
          ];
        };

      # nix run .#<app>
      apps = {
        hermes = mkApp { name = "hermes"; drv = packages.hermes; };
        gaia = mkApp { name = "gaia"; drv = packages.gaia; exePath = "/bin/gaiad"; };
        cosmovisor = mkApp { name = "cosmovisor"; drv = packages.cosmovisor; };
        stoml = mkApp { name = "stoml"; drv = packages.stoml; };
        sconfig = mkApp { name = "sconfig"; drv = packages.sconfig; };
        gm = mkApp { name = "gm"; drv = packages.gm; };
      };
    });
}
