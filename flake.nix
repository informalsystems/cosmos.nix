{
  description = "A reproducible Cosmos";

  inputs = {
    # Nix Inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    flake-utils.url = "github:numtide/flake-utils";

    # Rust Inputs
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

    gaia5-src = {
      flake = false;
      url = github:cosmos/gaia/v5.0.5;
    };

    gaia4-src = {
      flake = false;
      url = github:cosmos/gaia/v4.2.1;
    };

    cosmos-sdk-src = {
      flake = false;
      url = github:cosmos/cosmos-sdk;
    };

    thor-src = {
      flake = false;
      url = github:thorchain/thornode;
    };

    osmosis-src = {
      flake = false;
      url = github:osmosis-labs/osmosis;
    };
  };

  outputs =
    { self
    , nixpkgs
    , pre-commit-hooks
    , flake-utils
    , naersk
    , gomod2nix
    , stoml-src
    , sconfig-src
    , ibc-rs-src
    , gaia4-src
    , gaia5-src
    , cosmos-sdk-src
    , thor-src
    , osmosis-src
    }:
      with flake-utils.lib;
      eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ gomod2nix.overlay ];
        };
        goProjectSrcs = {
          gaia5 = { inputName = "gaia5-src"; storePath = "${gaia5-src}"; };
          gaia4 = { inputName = "gaia4-src"; storePath = "${gaia4-src}"; };
          stoml = {
            inputName = "stoml-src";
            storePath = "${stoml-src}";
          };
          sconfig = {
            inputName = "sconfig-src";
            storePath = "${sconfig-src}";
          };
          cosmovisor = {
            inputName = "cosmos-sdk-src";
            storePath = "${cosmos-sdk-src}/cosmovisor";
          };
          cosmos-sdk = { inputName = "cosmos-sdk-src"; storePath = "${cosmos-sdk-src}"; };
          thor = { inputName = "thor-src"; storePath = "${thor-src}"; };
          osmosis = {
            inputName = "osmosis-src";
            storePath = "${osmosis-src}";
          };
          cosmovisor = {
            inputName = "cosmos-sdk-src";
            storePath = "${cosmos-sdk-src}/cosmovisor";
          };
          osmosis = {
            inputName = "osmosis-src";
            storePath = "${osmosis-src}";
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
            hermes = naersk.lib."${system}".buildPackage {
              pname = "ibc-rs";
              root = ibc-rs-src;
              buildInputs = with pkgs; [ rustc cargo pkgconfig ];
              nativeBuildInputs = with pkgs; [ openssl ];
            };
            cosmovisor = (import ./cosmovisor) {
              inherit pkgs;
              cosmovisor-src = goProjectSrcs.cosmovisor.storePath;
            };
            cosmos-sdk = (import ./cosmos-sdk) {
              inherit pkgs;
              cosmos-sdk-src =
                # We need a version of cosmos-sdk with no cosmovisor
                # since buildGoApplication doesn't know how to handle
                # sub-applications
                pkgs.stdenv.mkDerivation {
                  name = "cosmos-sdk-no-cosmovisor";
                  unpackPhase = "true";
                  buildPhase = "true";
                  installPhase = ''
                    mkdir -p $out

                    for x in ${cosmos-sdk-src}/*; do
                      if [ $x = "${cosmos-sdk-src}/cosmovisor" ]
                        then continue
                        else cp -r $x $out
                      fi
                    done
                  '';
                };
            };
            gaia5 = (import ./gaia5) { inherit gaia5-src pkgs; };
            gaia4 = (import ./gaia4) { inherit gaia4-src pkgs; };
            thor = (import ./thor) { inherit pkgs thor-src; };
            osmosis = (import ./osmosis) { inherit pkgs osmosis-src; };
          };

        # nix flake check
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              nix-linter.enable = true;
              sync-go-modules = {
                enable = true;
                name = "sync-go-modules";
                entry = "${syncGoModulesCheck} -l";
                files = "(\\.(lock|narHash)|flake.nix)$";
                language = "system";
                pass_filenames = false;
              };
            };
          };
        } // packages; # adding packages here ensures that every attr gets built on check

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
            shellHook = ''
              GIT_REMOTE="$(${pkgs.git}/bin/git remote get-url origin 2> /dev/null)"
              REMOTE_BASENAME="$(${pkgs.coreutils}/bin/basename "$GIT_REMOTE")"
              if [[ $REMOTE_BASENAME == *"cosmos.nix"* && (-d .git || -f .git) ]]
              then
                ${self.checks.${system}.pre-commit-check.shellHook}
              else
                echo "You are in a remote cosmos.nix shell"
              fi
            '';
            nativeBuildInputs = with pkgs; [
              rustc
              cargo
              pkg-config
            ];
            buildInputs = with pkgs; [
              # need to prefix with pkgs because they shadow the name of inputs
              pkgs.gomod2nix
              openssl
              syncGoModulesScript
              shellcheck

              # gaia manager dependencies
              packages.stoml
              packages.sconfig
              gnused
            ] ++ builtins.attrValues packages;
          };

        # nix run .#<app>
        apps = {
          hermes = mkApp { name = "hermes"; drv = packages.hermes; };
          gaia = mkApp { name = "gaia"; drv = packages.gaia5; exePath = "/bin/gaiad"; };
          gaia4 = mkApp { name = "gaia"; drv = packages.gaia4; exePath = "/bin/gaiad"; };
          gaia5 = mkApp { name = "gaia"; drv = packages.gaia5; exePath = "/bin/gaiad"; };
          cosmovisor = mkApp { name = "cosmovisor"; drv = packages.cosmovisor; };
          simd = mkApp { name = "simd"; drv = packages.cosmos-sdk; };
          stoml = mkApp { name = "stoml"; drv = packages.stoml; };
          sconfig = mkApp { name = "sconfig"; drv = packages.sconfig; };
          gm = mkApp { name = "gm"; drv = packages.gm; };
          bifrost = mkApp { name = "thor"; drv = packages.thor; exePath = "/bin/bifrost"; };
          thorcli = mkApp { name = "thor"; drv = packages.thor; exePath = "/bin/thorcli"; };
          thord = mkApp { name = "thor"; drv = packages.thor; exePath = "/bin/thord"; };
          osmosis = mkApp { name = "osmosis"; drv = packages.osmosis; exePath = "/bin/osmosisd"; };
        };
      });
}
