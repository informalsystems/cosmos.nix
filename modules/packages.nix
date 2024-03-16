# This is the core module, and is where all the cosmos package derivations are stored.
{inputs, ...}: {
  perSystem = {
    pkgs,
    cosmosLib,
    self',
    system,
    ...
  }: {
    packages = with inputs.nixpkgs.lib;
      lists.foldl recursiveUpdate
      # This is the base attrset where we put individual packages, sometimes it
      # makes sense to group like packages together (i.e. all the different gaia versions)
      # in a single file. We recursively merge those attrsets that live in separate files
      # in the list that is the last argument to the `foldl` above.
      {
        akash = import ../packages/akash.nix {
          inherit (inputs) akash-src;
          inherit (cosmosLib) mkCosmosGoApp;
        };
        beaker = import ../packages/beaker.nix {
          inherit pkgs;
          inherit (inputs) beaker-src;
        };
        celestia-app = import ../packages/celestia-app.nix {
          inherit (inputs) celestia-app-src;
          inherit (cosmosLib) mkCosmosGoApp;
        };
        celestia-node = import ../packages/celestia-node.nix {
          inherit (inputs) celestia-node-src;
          inherit (cosmosLib) mkCosmosGoApp;
        };
        celestia = pkgs.symlinkJoin {
          name = "celestia";
          paths = [self'.packages.celestia-app self'.packages.celestia-node];
        };
        centauri = import ../packages/centauri.nix {
          inherit (inputs) composable-cosmos-src;
          inherit (self'.packages) libwasmvm_1_2_6;
          inherit cosmosLib;
        };
        cometbft = import ../packages/cometbft.nix {
          inherit (pkgs) buildGoModule;
          inherit (inputs) cometbft-src;
        };
        cosmwasm-check = import ../packages/cosmwasm-check.nix {
          inherit pkgs;
          inherit (inputs) cosmwasm-src;
        };
        cosmovisor = import ../packages/cosmovisor.nix {
          inherit (pkgs) buildGoModule;
          inherit (inputs) cosmos-sdk-src;
        };
        crescent = import ../packages/crescent.nix {
          inherit (inputs) crescent-src;
          inherit (cosmosLib) mkCosmosGoApp;
        };
        cw20-base = import ../packages/cw20-base.nix {
          inherit (cosmosLib) buildCosmwasmContract;
          inherit (inputs) cw-plus-src;
        };
        dydx = import ../packages/dydx.nix {
          inherit (cosmosLib) mkCosmosGoApp;
          inherit (inputs) dydx-src;
        };
        dymension = import ../packages/dymension.nix {
          inherit (cosmosLib) mkCosmosGoApp;
          inherit (inputs) dymension-src;
        };
        gex = import ../packages/gex.nix {
          inherit (pkgs) buildGoModule;
          inherit (inputs) gex-src;
        };
        gm = import ../packages/gm.nix {inherit pkgs inputs;};
        haqq = inputs.haqq-src.packages.${system}.haqq;
        hermes = import ../packages/hermes.nix {
          inherit pkgs;
          inherit (inputs) hermes-src;
        };
        ica = import ../packages/ica.nix {
          inherit (pkgs) buildGoModule;
          inherit (inputs) ica-src;
        };
        ignite-cli = import ../packages/ignite-cli.nix {
          inherit (pkgs) buildGoModule;
          inherit (inputs) ignite-cli-src;
        };
        interchain-security = import ../packages/interchain-security.nix {
          inherit (cosmosLib) mkCosmosGoApp;
          inherit (inputs) interchain-security-src;
        };
        ixo = import ../packages/ixo.nix {
          inherit (pkgs) buildGoModule;
          inherit (inputs) ixo-src;
        };
        juno = import ../packages/juno.nix {
          inherit (inputs) juno-src;
          inherit (self'.packages) libwasmvm_1_3_0;
          inherit cosmosLib;
        };
        migaloo = import ../packages/migaloo.nix {
          inherit (inputs) migaloo-src;
          inherit (self'.packages) libwasmvm_1_2_3;
          inherit cosmosLib;
        };
        neutron = import ../packages/neutron.nix {
          inherit (inputs) neutron-src;
          inherit (self'.packages) libwasmvm_1_5_0;
          inherit cosmosLib;
        };
        andromeda = import ../packages/andromeda.nix {
          inherit (inputs) andromeda-src;
          inherit (self'.packages) libwasmvm_1_3_0;
          inherit cosmosLib;
        };
        injective = import ../packages/injective.nix {
          inherit (inputs) injective-src;
          inherit (self'.packages) libwasmvm_1_5_0;
          inherit cosmosLib;
        };
        osmosis = import ../packages/osmosis.nix {
          inherit (inputs) osmosis-src;
          inherit (self'.packages) libwasmvm_1_5_0;
          inherit cosmosLib;
        };
        provenance = import ../packages/provenance.nix {
          inherit (inputs) provenance-src;
          inherit (self'.packages) libwasmvm_1_2_4;
          inherit cosmosLib;
        };
        regen = import ../packages/regen.nix {
          inherit (inputs) regen-src;
          inherit (cosmosLib) mkCosmosGoApp;
        };
        relayer = import ../packages/relayer.nix {
          inherit (pkgs) buildGoModule;
          inherit (inputs) relayer-src;
        };
        sentinel = import ../packages/sentinel.nix {
          inherit (inputs) sentinel-src;
          inherit (cosmosLib) mkCosmosGoApp;
        };
        sifchain = import ../packages/sifchain.nix {
          inherit (cosmosLib) mkCosmosGoApp;
          inherit (inputs) sifchain-src;
        };
        simd = import ../packages/simd.nix {
          inherit (pkgs) buildGoModule;
          inherit (inputs) cosmos-sdk-src;
        };
        slinky = import ../packages/slinky.nix {
          inherit (cosmosLib) mkCosmosGoApp;
          inherit (inputs) slinky-src;
        };
        umee = import ../packages/umee.nix {
          inherit (cosmosLib) mkCosmosGoApp;
          inherit (inputs) umee-src;
        };
        wasmd = import ../packages/wasmd.nix {
          inherit (inputs) wasmd-src;
          inherit (self'.packages) libwasmvm_1_1_1;
          inherit cosmosLib;
        };
        wasmd_next = import ../packages/wasmd_next.nix {
          inherit (inputs) wasmd_next-src;
          inherit (self'.packages) libwasmvm_1_2_3;
          inherit cosmosLib;
        };
        rollapp-evm = import ../packages/rollapp-evm.nix {
          inherit (cosmosLib) mkCosmosGoApp;
          inherit (inputs) rollapp-evm-src;
        };
      }
      # This list contains attr sets that are recursively merged into the
      # base attrset
      ([
          # Gaia
          (import ../packages/gaia.nix {
            inherit inputs;
            inherit (cosmosLib) mkCosmosGoApp;
          })
          # IBC Go
          (import ../packages/ibc-go.nix {
            inherit inputs;
            inherit (cosmosLib) mkCosmosGoApp;
          })
          # Libwasm VM
          (import ../packages/libwasmvm.nix {inherit inputs pkgs system;})

          # Stride
          (import ../packages/stride.nix {
            inherit inputs;
            inherit (cosmosLib) mkCosmosGoApp;
          })
          # Evmos
          (import ../packages/evmos {
            inherit pkgs;
            inherit (inputs) evmos-src;
            inherit (cosmosLib) mkGenerator;
          })
        ]
        ## Linux only packages
        ++ (lists.optionals pkgs.stdenv.isLinux
          [
            {
              apalache = import ../packages/apalache.nix {
                inherit pkgs;
                inherit (inputs) apalache-src;
              };
            }
            {
              stargaze = import ../packages/stargaze.nix {
                inherit (inputs) stargaze-src;
                inherit (self'.packages) libwasmvm_1beta7;
                inherit cosmosLib;
              };
            }
            {
              namada = import ../packages/namada.nix {
                inherit pkgs;
                inherit (inputs) namada-src;
              };
            }
          ])
        ## Darwin only packages
        ++ (lists.optionals pkgs.stdenv.isDarwin
          []));
  };
}
