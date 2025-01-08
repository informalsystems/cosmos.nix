{inputs, ...}:
#` This output allows you to run any of the packages by invoking the following command.
#
# from outside this git repo:
# nix run github:informalsystems/cosmos.nix#<app-name>
#
# within this git repo:
# nix run .#<app-name>
{
  perSystem = {
    self',
    pkgs,
    ...
  }: {
    apps = with self'; let
      scripts = import ../scripts {inherit pkgs;};
    in
      with inputs.nixpkgs.lib;
        lists.foldl recursiveUpdate
        {
          dydx = {
            type = "app";
            program = "${packages.dydx}/bin/dydxprotocold";
          };
          cometbft = {
            type = "app";
            program = "${packages.cometbft}/bin/cometbft";
          };
          haqq = {
            type = "app";
            program = "${packages.haqq}/bin/haqqd";
          };
          hermes = {
            type = "app";
            program = "${packages.hermes}/bin/hermes";
          };
          gaia5 = {
            type = "app";
            program = "${packages.gaia5}/bin/gaiad";
          };
          gaia6 = {
            type = "app";
            program = "${packages.gaia6}/bin/gaiad";
          };
          gaia6-ordered = {
            type = "app";
            program = "${packages.gaia6-ordered}/bin/gaiad";
          };
          gaia7 = {
            type = "app";
            program = "${packages.gaia7}/bin/gaiad";
          };
          gaia8 = {
            type = "app";
            program = "${packages.gaia8}/bin/gaiad";
          };
          gaia9 = {
            type = "app";
            program = "${packages.gaia9}/bin/gaiad";
          };
          gaia10 = {
            type = "app";
            program = "${packages.gaia10}/bin/gaiad";
          };
          gaia11 = {
            type = "app";
            program = "${packages.gaia11}/bin/gaiad";
          };
          gaia12 = {
            type = "app";
            program = "${packages.gaia12}/bin/gaiad";
          };
          gaia13 = {
            type = "app";
            program = "${packages.gaia13}/bin/gaiad";
          };
          gaia14 = {
            type = "app";
            program = "${packages.gaia14}/bin/gaiad";
          };
          gaia15 = {
            type = "app";
            program = "${packages.gaia15}/bin/gaiad";
          };
          gaia17 = {
            type = "app";
            program = "${packages.gaia17}/bin/gaiad";
          };
          gaia19 = {
            type = "app";
            program = "${packages.gaia19}/bin/gaiad";
          };
          gaia20 = {
            type = "app";
            program = "${packages.gaia20}/bin/gaiad";
          };
          gaia-main = {
            type = "app";
            program = "${packages.gaia-main}/bin/gaiad";
          };
          ica = {
            type = "app";
            program = "${packages.ica}/bin/icad";
          };
          cosmovisor = {
            type = "app";
            program = "${packages.cosmovisor}/bin/cosmovisor";
          };
          simd = {
            type = "app";
            program = "${packages.simd}/bin/simd";
          };
          slinky = {
            type = "app";
            program = "${packages.slinky}/bin/slinkyd";
          };
          ibc-go-v7-simapp = {
            type = "app";
            program = "${packages.ibc-go-v7-simapp}/bin/simd";
          };
          ibc-go-v8-simapp = {
            type = "app";
            program = "${packages.ibc-go-v8-simapp}/bin/simd";
          };
          ibc-go-v9-simapp = {
            type = "app";
            program = "${packages.ibc-go-v9-simapp}/bin/simd";
          };
          ibc-go-v7-wasm-simapp = {
            type = "app";
            program = "${packages.ibc-go-v7-wasm-simapp}/bin/simd";
          };
          ibc-go-v8-wasm-simapp = {
            type = "app";
            program = "${packages.ibc-go-v8-wasm-simapp}/bin/simd";
          };
          ignite-cli = {
            type = "app";
            program = "${packages.ignite-cli}/bin/ignite";
          };
          interchain-security = {
            type = "app";
            program = "${packages.interchain-security}/bin/interchain-security";
          };
          gm = {
            type = "app";
            program = "${packages.gm}/bin/gm";
          };
          osmosis = {
            type = "app";
            program = "${packages.osmosis}/bin/osmosisd";
          };
          centauri = {
            type = "app";
            program = "${packages.centauri}/bin/centaurid";
          };
          regen = {
            type = "app";
            program = "${packages.regen}/bin/regen";
          };
          evmos = {
            type = "app";
            program = "${packages.evmos}/bin/evmosd";
          };
          juno = {
            type = "app";
            program = "${packages.juno}/bin/junod";
          };
          sentinel = {
            type = "app";
            program = "${packages.sentinel}/bin/sentinelhub";
          };
          akash = {
            type = "app";
            program = "${packages.akash}/bin/akash";
          };
          umee = {
            type = "app";
            program = "${packages.umee}/bin/umeed";
          };
          ixo = {
            type = "app";
            program = "${packages.ixo}/bin/ixod";
          };
          sifchain = {
            type = "app";
            program = "${packages.sifchain}/bin/sifnoded";
          };
          wasmd = {
            type = "app";
            program = "${packages.wasmd}/bin/wasmd";
          };
          stride = {
            type = "app";
            program = "${packages.stride}/bin/strided";
          };
          stride-no-admin = {
            type = "app";
            program = "${packages.stride-no-admin}/bin/strided";
          };
          migaloo = {
            type = "app";
            program = "${packages.migaloo}/bin/migalood";
          };
          celestia-app = {
            type = "app";
            program = "${packages.celestia}/bin/celestia-appd";
          };
          celestia-node = {
            type = "app";
            program = "${packages.celestia-node}/bin/celestia";
          };
          provenance = {
            type = "app";
            program = "${packages.provenance}/bin/provenanced";
          };
          dymension = {
            type = "app";
            program = "${packages.dymension}/bin/dymd";
          };
          push-store = {
            type = "app";
            program = "${scripts.push-store}/bin/push-store";
          };
        }
        ([]
          ## Linux only apps
          ++ (lists.optionals pkgs.stdenv.isLinux
            [
              {
                apalache = {
                  type = "app";
                  program = "${packages.apalache}/bin/apalache-mc";
                };
              }
              {
                stargaze = {
                  type = "app";
                  program = "${packages.stargaze}/bin/starsd";
                };
              }
              {
                namada = {
                  type = "app";
                  program = "${packages.namada}/bin/namada";
                };
              }
            ])
          ## Darwin only apps
          ++ (lists.optionals pkgs.stdenv.isDarwin
            []));
  };
}
