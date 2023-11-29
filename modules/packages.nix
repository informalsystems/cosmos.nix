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
        apalache = import ../packages/apalache.nix {
          inherit pkgs;
          inherit (inputs) apalache-src;
        };
        beaker = import ../packages/beaker.nix {
          inherit pkgs;
          inherit (inputs) beaker-src;
        };
        celestia = import ../packages/celestia.nix {
          inherit (inputs) celestia-src;
          inherit (cosmosLib) mkCosmosGoApp;
        };
        centauri = import ../packages/centauri.nix {
          inherit (inputs) centauri-src;
          inherit (self'.packages) libwasmvm_1_2_4;
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
        evmos = import ../packages/evmos.nix {
          inherit (inputs) evmos-src;
          inherit (cosmosLib) mkCosmosGoApp;
        };
        gex = import ../packages/gex.nix {
          inherit (pkgs) buildGoModule;
          inherit (inputs) gex-src;
        };
        gm = import ../packages/gm.nix {inherit pkgs inputs;};
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
          inherit (self'.packages) libwasmvm_1_2_3;
          inherit cosmosLib;
        };
        osmosis = import ../packages/osmosis.nix {
          inherit (inputs) osmosis-src;
          inherit (self'.packages) libwasmvm_1_2_3;
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
        stargaze = import ../packages/stargaze.nix {
          inherit (inputs) stargaze-src;
          inherit (self'.packages) libwasmvm_1beta7;
          inherit cosmosLib;
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
        cw20-base = import ../packages/cw20-base.nix {
          inherit (inputs) cw-plus-src;
          inherit (pkgs) rustPlatform;
          inherit (cosmosLib) buildCosmwasmContract;
        };        
      }
      # This list contains attr sets that are recursively merged into the
      # base attrset
      [
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
      ];
  };
}
