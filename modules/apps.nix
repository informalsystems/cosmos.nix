#` This output allows you to run any of the packages by invoking the following command.
#
# from outside this git repo:
# nix run github:informalsystems/cosmos.nix#<app-name>
#
# within this git repo:
# nix run .#<app-name>
{
  perSystem = {self', ...}: {
    apps = with self'; {
      cometbft = {
        type = "app";
        program = "${packages.cometbft}/bin/cometbft";
      };
      hermes = {
        type = "app";
        program = "${packages.hermes}/bin/hermes";
      };
      gaia = {
        type = "app";
        program = "${packages.gaia6_0_3}/bin/gaiad";
      };
      gaia4 = {
        type = "app";
        program = "${packages.gaia4}/bin/gaiad";
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
      ibc-go-v7-simapp = {
        type = "app";
        program = "${packages.ibc-go-v7-simapp}/bin/simd";
      };
      ibc-go-v8-simapp = {
        type = "app";
        program = "${packages.ibc-go-v8-simapp}/bin/simd";
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
      crescent = {
        type = "app";
        program = "${packages.crescent}/bin/crescentd";
      };
      stargaze = {
        type = "app";
        program = "${packages.stargaze}/bin/starsd";
      };
      wasmd = {
        type = "app";
        program = "${packages.wasmd}/bin/wasmd";
      };
      apalache = {
        type = "app";
        program = "${packages.apalache}/bin/apalache-mc";
      };
      stride = {
        type = "app";
        program = "${packages.stride}/bin/strided";
      };
      stride-consumer = {
        type = "app";
        program = "${packages.stride-consumer}/bin/strided";
      };
      stride-consumer-no-admin = {
        type = "app";
        program = "${packages.stride-consumer-no-admin}/bin/strided";
      };
      stride-no-admin = {
        type = "app";
        program = "${packages.stride-no-admin}/bin/strided";
      };
      migaloo = {
        type = "app";
        program = "${packages.migaloo}/bin/migalood";
      };
      celestia = {
        type = "app";
        program = "${packages.celestia}/bin/celestia-appd";
      };
      provenance = {
        type = "app";
        program = "${packages.provenance}/bin/provenanced";
      };
      namada = {
        type = "app";
        program = "${packages.namada}/bin/namada";
      };
    };
  };
}
