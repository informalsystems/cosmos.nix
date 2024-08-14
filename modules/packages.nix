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
        centauri-oci = import ../packages/centauri-oci.nix {
          inherit (pkgs) nix2container;
          inherit (self'.packages) centauri;
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
        gaia-oci = import ../packages/gaia-oci.nix {
          inherit (pkgs) nix2container;
          gaia = self'.packages.gaia14;
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
          inherit (self'.packages) libwasmvm_1_5_2;
          inherit cosmosLib;
        };
        migaloo = import ../packages/migaloo.nix {
          inherit (inputs) migaloo-src;
          inherit (self'.packages) libwasmvm_1_5_2;
          inherit cosmosLib;
        };
        neutron = import ../packages/neutron.nix {
          inherit (inputs) neutron-src;
          inherit (self'.packages) libwasmvm_2_0_0;
          inherit cosmosLib;
        };
        andromeda = import ../packages/andromeda.nix {
          inherit (inputs) andromeda-src;
          inherit (self'.packages) libwasmvm_1_3_0;
          inherit cosmosLib;
        };
        osmosis = import ../packages/osmosis.nix {
          inherit (inputs) osmosis-src;
          inherit (self'.packages) libwasmvm_1_5_2;
          inherit cosmosLib;
        };
        osmosis-oci = import ../packages/osmosis-oci.nix {
          inherit (pkgs) nix2container;
          inherit (self'.packages) osmosis;
        };
        provenance = import ../packages/provenance.nix {
          inherit (inputs) provenance-src;
          inherit (self'.packages) libwasmvm_2_1_0;
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
          inherit (self'.packages) libwasmvm_2_1_0;
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
            inherit inputs cosmosLib;
            inherit (cosmosLib) mkCosmosGoApp;
            inherit (self'.packages) libwasmvm_1_5_0;
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
            inherit (self'.packages) libwasmvm_1_5_2;
            inherit (cosmosLib) mkCosmosGoApp;
            inherit cosmosLib;
          })
          # Evmos
          (import ../packages/evmos {
            inherit pkgs;
            inherit (inputs) evmos-src;
            inherit (cosmosLib) mkGenerator;
          })
          # Injective
          (import ../packages/injective {
            inherit pkgs;
            inherit system;
            inherit (inputs) injective-src;
            inherit (cosmosLib) mkGenerator;
            inherit cosmosLib;
            inherit (self'.packages) libwasmvm_2_0_0;
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
            # fails with gaia nill pointer, so need to have config builder for cosmos-sdk too
            # {
            #   hermes-test = import ../nixosTests/tests/hermes-test.nix {
            #     inherit pkgs;
            #     inherit (inputs) nix-std;
            #     inherit (self'.packages) hermes;
            #     gaia = self'.packages.gaia14;
            #   };
            # }
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
