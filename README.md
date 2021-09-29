# Cosmos.nix

This is an experimental Nix project for integrating the Rust and Go projects in Cosmos
as Nix packages. Use this at your own risk.

## Setup

### Non-NixOS

This project is developed entirely in [Nix Flakes](https://nixos.wiki/wiki/Flakes).
To get started, run the following:

[Install Nix](https://nixos.org/download.html):

```bash
$ curl -L https://nixos.org/nix/install | sh
```

[Install Nix Unstable](https://serokell.io/blog/practical-nix-flakes):

```bash
$ nix-env -f '<nixpkgs>' -iA nixUnstable
```

[Enable experimental features](https://serokell.io/blog/practical-nix-flakes):

```bash
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

[Setup Caches](https://nixos.org/manual/nix/unstable/package-management/sharing-packages.html)

##### Cache Setup with Cachix

With nix installed you can run `nix-env -iA cachix -f https://cachix.org/api/v1/install`.
You can check that this worked by running `cachix --version`.

You can now run these commans to add all of our cachix caches:

```bash
$ cachix use cosmos
$ cachix use pre-commit-hooks
$ cachix use nix-community
```

##### Manual Cache Setup

Add these lines to your Nix config (either ~/.config/nix/nix.conf [for MacOS] or
/etc/nix/nix.conf [for flavors of Linux, depending on your distro]):

```
extra-substituters = https://cache.nixos.org https://nix-community.cachix.org https://pre-commit-hooks.cachix.org https://cosmos.cachix.org
trusted-public-keys = nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc= cosmos.cachix.org-1:T5U9yg6u2kM48qAOXHO/ayhO8IWFnv0LOhNcq0yKuR8=
cores = 4 # NB: You may want to increase this on machines with more cores
```

### NixOS

In your `configuration.nix` file you can add code below. It does 2 things, the
first is that it enables nix experimental features (which enables flakes) and
second it adds cache information so you don't have to build everything yourself.
Note, you can add the suggested binary caches in addition to your existing ones.

```nix
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    binaryCaches = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://pre-commit-hooks.cachix.org"
      "https://cosmos.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      "cosmos.cachix.org-1:T5U9yg6u2kM48qAOXHO/ayhO8IWFnv0LOhNcq0yKuR8="
    ];
   };
```

## Shell

If you are just here for a remote nix shell (a development environment where
you don't need to clone the repo) you can run the following command:

```bash
nix develop github:informalsystems/cosmos.nix#cosmos-shell
```

This will build the development environment. The environment will then be
cached in your nix store and should be very fast. If you want to pull the
latest development environment you should run:

```bash
nix develop github:informalsystems/cosmos.nix#cosmos-shell --refresh
```

## Applications

> Note: every command has a local and a remote variant. The local variant requires
> that the command is run from within the cloned repo. The remote variant can be run
> from wherever.
>
> Local: nix run .#<app-name>
> Remote: nix run github:informalsystems/cosmos.nix#<app-name>
>
> For brevity and consistency all the commands are listed in the local variant

### Packages provided

#### Relayers
- [hermes](https://hermes.informal.systems/): `nix run .#hermes`
- [ts-relayer](https://github.com/confio/ts-relayer):
  - `nix run .#ts-relayer`
  - `nix run .#ts-relayer-setup`
- [relayer](https://github.com/cosmos/relayer): `nix run .#relayer`

#### Validators
- [thor](https://github.com/thorchain/thornode):
  - bifrost: `nix run .#bifrost`
  - thorcli: `nix run .#thorcli`
  - thord: `nix run .#thord`
- [osmosis](https://github.com/osmosis-labs/osmosis): `nix run .#osmosis`
- [gravity dex](https://github.com/b-harvest/gravity-dex-backend): `nix run .#gdex`
- [iris](https://github.com/irisnet/irishub): `nix run .#iris`
- [regen](https://github.com/regen-network/regen-ledger): `nix run .#regen`
- [ethermint](https://github.com/tharsis/ethermint): `nix run .#ethermint`
- [juno](https://github.com/CosmosContracts/juno): `nix run .#juno`

#### Development Tools
- [gaia](https://hub.cosmos.network/main/gaia-tutorials/what-is-gaia.html): `nix run .#gaia`
- [cosmovisor](https://docs.cosmos.network/master/run-node/cosmovisor.html): `nix run .#cosmovisor`
- [simd](https://docs.cosmos.network/master/run-node/interact-node.html): `nix run .#simd`
- [gm](https://github.com/informalsystems/ibc-rs/tree/master/scripts/gm): `nix run .#gm`
